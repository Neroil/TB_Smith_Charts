= Architecture <architecture>

L'application est un logiciel qui doit afficher des éléments graphiques complexes (l'abaque) et permettre à l'utilisateur de visualiser des données pour effectuer l'adaptation d'impédance.

Comme annoncé dans l'état de l'art, la bibliothèque JavaFX permet de concevoir ce type d'application en utilisant le pattern "MVVM" (Model-View-ViewModel).

#figure(image("../images/schemaUMLSimple.png", width:100%),
caption: [Schéma simplifié de l'architecture du projet])

== Partie Vue

La vue de l'application est, comme son nom l'indique, ce que l'utilisateur peut voir. C'est la partie émergée de l'iceberg. Dans une application JavaFX, elle se manifeste principalement par un fichier *.fxml*. C'est ce fichier qui est édité via l'outil Scene Builder pour modifier graphiquement l'interface utilisateur.

Ce fichier fxml est complété par une bibliothèque d'éléments d'interface utilisateur moderne AtlantaFX et d'une feuille CSS pour davantage personnaliser l'interface.

En plus de ce fichier qui gère les éléments simples, il a fallu mettre en place plusieurs classes spécifiques pour chaque élément, visibles sur le diagramme :

- `SmithChartRenderer` : Cette classe s'occupe de dessiner l'abaque de Smith sur un Canvas. Elle redessine la grille, les cercles VSWR et les tracés d'impédance à chaque changement de données.

- `SmithChartLayout` : Une classe utilitaire qui gère les conversions entre coordonnées gamma (complexe) et coordonnées pixel à l'écran. Elle centralise les calculs de positionnement sur le canvas.

- `CircuitRenderer` : De la même manière, cette classe dessine le schéma électrique du circuit en fonction des composants ajoutés (résistances, lignes, etc.).

- `S1PPlotterWindow` : Une fenêtre dédiée pour afficher les données d'un fichier S1P sous forme de diagramme cartésien (Log Magnitude / Fréquence).

- `ChartPoint` : Une classe utilitaire qui sert à gérer la détection de la souris sur les points du graphique ("hit detection") pour afficher les infobulles (tooltips).

- `Les Dialogues personnalisés` : Plusieurs classes (comme `SweepDialog` ou `ComplexInputDialog`) ont été créées pour demander des informations complexes à l'utilisateur. Vu leur complexité, il était nécessaire de créer des classes supplémentaires pour les organiser.

Enfin, une classe utilitaire `StageController` a été ajoutée pour gérer le titre de la fenêtre principale, notamment pour indiquer visuellement à l'utilisateur si le projet contient des modifications non sauvegardées (ajout d'un astérisque \* dans le titre).

=== MainController

La logique de l'interface est gérée par les contrôleurs. JavaFX fournit une possibilité de faire le lien entre les différents boutons et interactions avec le contrôleur principal de l'application, le `MainController`, qui fait le lien entre les boutons de l'interface et les fonctions du programme grâce à l'annotation `@FXML`. C'est cette classe que JavaFX consulte pour effectuer les actions lorsqu'on appuie sur des boutons.

Le `MainController` s'occupe principalement de :

- *Gestion des menus et actions utilisateur* : Importer/exporter des fichiers S1P, créer/sauvegarder des projets, gérer les circuits multiples, etc.

- *Binding avec le ViewModel* : Synchroniser les champs de texte (fréquence, impédance) avec les propriétés observables du ViewModel, mettre à jour les tables de données, etc.

- *Orchestration des dialogues* : Ouvrir les fenêtres de configuration (sweep, ajout de composants, édition de valeurs) et traiter leurs résultats.

- *Gestion de l'état de l'interface* : Afficher/masquer des sections selon le contexte (panneau S1P lorsqu'un fichier est chargé, panneau de sweep lors d'une simulation, etc.).

- *Coordination avec CircuitRenderer* : Redessiner le schéma électrique à chaque modification du circuit.

Cependant, vu la richesse des interactions possibles sur l'abaque (zoom, pan, ajout à la souris), le `MainController` devenait trop chargé. Une classe `SmithChartInteractionController` a donc été introduite pour déléguer toute la logique spécifique aux interactions avec l'abaque de Smith. Le `MainController` reste ainsi focalisé sur l'orchestration globale de la fenêtre et des menus.

=== SmithChartInteractionController

Dès qu'une action touchant à l'abaque est réalisée, le contrôleur appelle la fonction `redrawSmithCanvas`. Dans la version 1.0 de ce projet, cette fonction est sollicitée à de très nombreux endroits (plus de 30 fois). Elle demande ensuite au `SmithChartRenderer` de redessiner l'abaque entièrement. Le dessin complet est très rapide, donc le refaire entièrement n'est pas un problème (environ 0,05 ms lorsque l'abaque est vide et environ 0,1 ms lorsqu'il y a un fichier S1P chargé et que l'on change les composants, ce qui déplace tous les points sur l'abaque).

Pour éviter de surcharger le processeur avec des calculs inutiles (par exemple lors d'un redimensionnement rapide de la fenêtre ou d'un mouvement de souris), un mécanisme de *debouncing* a été mis en place. L'opération active un flag sur le ViewModel, nommé `isRedrawing`.

L'opération de dessin est ensuite déléguée au thread d'interface via la fonction JavaFX `Platform.runLater`. Si une nouvelle demande de dessin arrive alors que le flag est encore à `true`, elle est ignorée. Une fois le dessin terminé, le drapeau repasse à `false`. Cette optimisation permet d'éliminer énormément de demandes de dessin superflues et d'éviter des freezes de l'interface utilisateur. Après quelques tests simples d'utilisation, dépendamment de ce qui est effectué, cette fonction de debouncing permet d'éviter le dessin inutile d'environ 40 pourcents des demandes de dessin (entre 10 et 80 pourcents selon les actions).

C'est aussi ce contrôleur qui gère la fonctionnalité extrêmement importante d'ajout à la souris (`handleMouseMagnetization`). Lorsqu'un utilisateur ajoute un composant visuellement, le curseur ne se déplace pas librement, il doit se magnétiser au comportement souhaité du composant qu'on ajoute. Par exemple, un condensateur en parallèle va suivre un cercle de conductance constante et afficher en temps réel l'effet qu'a le composant sur le circuit d'adaptation. Le contrôleur calcule en temps réel la projection de la souris sur ces cercles mathématiques pour garantir que les valeurs affichées restent physiquement cohérentes.

Cette fonction complexe utilise de nombreuses fonctions de la classe `SmithCalculator` pour effectuer les calculs qui seront expliqué plus bas dans le rapport. 

Le système projette le mouvement de la souris sur le vecteur tangent au cercle, convertit ce déplacement linéaire en changement d'angle, puis recalcule la valeur du composant à chaque mouvement. Pour les lignes de transmission, le système permet une rotation infinie autour du cercle, tandis que pour les autres composants, l'angle est borné entre le point de départ et les limites physiques (circuit ouvert ou court-circuit).

Au début du projet, le mécanisme de magnétisation de la souris déplaçait directement le curseur de l'utilisateur à l'aide de la classe `Robot` de JavaFX. Cependant, lors de tests sur une machine Linux, un problème critique est apparu. Pour des raisons de sécurité de la plateforme Wayland (source : https://bugs.openjdk.org/browse/JDK-8307779), le système d'exploitation empêchait le déplacement programmatique de la souris. Cette fonctionnalité était donc inutilisable sur certaines plateformes.

Pour résoudre ce problème, il a fallu mettre en place un système de souris virtuelle basé sur deux Canvas superposés. L'un est le `smithCanvas`, le canvas principal qui contient l'abaque de Smith, les tracés d'impédance et les points de données. Ce canvas n'est redessiné que lorsque les données changent. Ensuite la nouveauté, le `cursorCanvas`, c'est un canvas transparent superposé au premier, dédié aux éléments interactifs temporaires (curseur virtuel, tooltips).

Lors de l'ajout d'un composant à la souris, un curseur virtuel est affiché sur le `cursorCanvas` à la position magnétisée correcte. L'utilisateur voit ainsi où le composant sera placé sans que la souris système ne bouge. Sur les machines Windows, la souris est tout de même déplacée mais est rendue invisible pour que le curseur personnalisé soit mis en évidence.

Le `cursorCanvas` est également utilisé pour afficher les informations lorsque l'utilisateur survole un point de l'abaque. Le système de détection (`ChartPoint`) vérifie si la souris se trouve assez près d'un point et déclenche l'affichage d'une petite fenêtre avec les informations du point (impédance, VSWR, facteur de qualité, etc.).

=== Filtrage des fichiers S1P

Le logiciel permet de simplement mettre en évidence des parties du fichier S1P importé sur l'interface. Après des discussions sur l'utilité de ces mises en évidence, le système a été mis en place de façon à avoir trois plages de mise en évidence au maximum. Essayer de créer un circuit d'adaptation qui permet de satisfaire trois plages est déjà très complexe, donc il était inutile d'en choisir plus.

Ces plages de fréquences sont définies par l'utilisateur via des contrôles de type `RangeSlider` dans l'interface. Chaque filtre peut être activé ou désactivé indépendamment via des propriétés booléennes (`filter1Enabled`, `filter2Enabled`, `filter3Enabled`) stockées dans le ViewModel. Pour chaque filtre actif, on définit une fréquence minimale et maximale (`freqRangeMinF1`/`freqRangeMaxF1`, etc.).

Lors du dessin de l'abaque, le `SmithChartRenderer` parcourt tous les points S1P transformés et appelle la méthode `whichFrequencyRange(frequency)` du ViewModel pour déterminer dans quelle plage se trouve chaque point. Cette méthode retourne 1, 2 ou 3 si le point appartient à l'un des trois filtres actifs, ou -1 si aucun filtre ne correspond.

Selon le résultat, le point est dessiné avec une couleur et un style différent, si le point ne se trouve dans aucune de ces plages, il est alors mis en retrait avec une opacité moindre pour éviter d'avoir trop de points sur l'abaque, l'utilisateur peut se focaliser sur les fréquences sur lesquelles il travail.

== Partie Modèle

Le modèle est le squelette des données de l'application, c'est la logique métier de l'application. Il contient les différents composants (`CircuitElement`), les unités, et la gestion des nombres complexes. C'est ici qu'on définit comment se comportent les éléments dans le plan physique.

=== Données et éléments du circuit

Le but de l'abaque de Smith est d'élaborer un circuit d'adaptation. Modéliser les différents composants est donc très important. Le logiciel permet d'ajouter quatre types de composants différents : 

*Les composants classiques (Résistance, Condensateur et Inducteur)* : Ces composants se comportent de façon similaire, on peut facilement calculer leur impédance complexe à partir de la fréquence du circuit que l'on construit. Ensuite on choisit si on ajoute cette impédance en série (une simple addition) ou bien en parallèle (et on utilise la fonction de `SmithCalculator` appelée `addParallelImpedance` qui effectue ce calcul $"Z Total" = 1 / ( (1/"Z Start") + (1/"Z Comp") )$, Z Comp étant l'impédance du composant qu'on ajoute). 

En plus de ça, un facteur de qualité (Q) a été mis en place pour les condensateurs et les inducteurs qui permet d'avoir des simulations de circuit d'adaptation plus réalistes. Ce facteur induit une résistance parasite :

- En série, on calcule une résistance de perte $"Rs" = abs(X)/Q$.

- En parallèle, on calcule une résistance de perte $"Rp" = abs(X) dot Q$.

Puisque la réactance (X) d'un condensateur est négative, nous utilisons sa valeur absolue pour garantir une résistance toujours positive. Selon la configuration choisie, cette résistance est combinée à la réactance pure pour former l'impédance réelle du composant.

*Les lignes de transmission* : Ces lignes se comportent très différemment des autres composants. Leur effet change drastiquement selon l'impédance d'entrée de la ligne, c'est pour cela que la manière de calculer l'impédance ne peut pas se faire de façon isolée. La classe `Line` implémente donc une méthode `calculateImpedance(currentImpedance, frequency)` qui prend en compte l'impédance actuelle du circuit, l'impédance au départ de la ligne.

Pour une ligne série (sans stub), on utilise la formule de transformation d'impédance @cours_milieu_cablés :

$ Z_"in" = Z_0 (Z_L + Z_0 tanh(gamma l))/(Z_0 + Z_L tanh(gamma l)) $

où $gamma = alpha + j beta$ est la constante de propagation complexe (qui prend en compte les pertes via le facteur de qualité réutilisé comme perte en dB/m), et $beta = (2 pi f)/c sqrt(epsilon_r)$ est la constante de phase.

Pour les stubs (court-circuit ou circuit ouvert), on travaille sur l'abaque des admittances. Un stub court-circuité donne $Y_"in" = Y_0 / tanh(gamma l)$ tandis qu'un stub ouvert donne $Y_"in" = Y_0 tanh(gamma l)$. Cette admittance est ensuite ajoutée en parallèle au circuit.

Tous ces composants héritent de la classe abstraite `CircuitElement` qui définie les propriétés communes tel que la valeur réelle du composant, la position (série ou parallèle). Cette position permet aussi de savoir si une ligne va être un stub ou non. Le facteur de qualité est aussi mis dans cette classe abstraite.

=== Les unités

Chaque composant utilise des unités différentes. Pour faciliter la rédaction du code et pour avoir un code plus "propre", un système de gestion des unités a été mis en place. Toutes les unités implémentent une interface `ElectronicUnit` qui présente la fonction `getFactor()` permettant d'obtenir le facteur de conversion de l'unité choisie vers son unité de base (ex : les picofarads ont comme facteur 1E-12). Ensuite, différents énumérations implémentent cette interface :

- `CapacitanceUnit` : pF, nF, μF, mF (conversion vers les farads)
- `InductanceUnit` : H, mH, μH, nH (conversion vers les henrys)
- `ResistanceUnit` : Ω, kΩ, MΩ (conversion vers les ohms)
- `DistanceUnit` : mm, m, km (conversion vers les mètres, utilisé pour les lignes de transmission)
- `FrequencyUnit` : Hz, kHz, MHz, GHz (conversion vers les hertz)

=== Les points de données

Lorsqu'on ajoute un composant sur l'abaque, on affiche aussi ses informations dans une partie de l'interface nommées "DataPoint". C'est une feature pour avoir accès directement aux informations de chaque point du circuit. La classe `DataPoint` encapsule toutes les informations nécessaire, tel que la fréquence du point, son nom (le label affiché), son impédance complexe, son coefficient de réflexion, le VSWR (Voltage Standing Wave Ratio), la perte de retour (Return Loss) en dB et finalement le facteur de qualité de chaque point. 

Ces datapoints sont aussi utilisés pour stocker les informations qui ne font pas partie du circuit, comme par exemple les informations liés aux sweeps ou bien aux fichiers S1P.

=== Gestion des fichiers S1P

La classe `TouchstoneS1P` est un parser développé pour cette application qui est capable de lire et d'exporter les fichiers .s1p selon le standard Touchstone. Ces fichiers commencent par une ligne d'options (précédée de \#) qui spécifie :
- L'unité de fréquence (Hz, kHz, MHz, GHz)
- Le type de paramètre (S, Y, Z, H, G - par défaut S pour les paramètres de répartition)
- Le format des données (DB pour dB/angle, MA pour magnitude/angle, RI pour réel/imaginaire - par défaut MA)
- La résistance de référence (R suivi de la valeur, par défaut 50Ω)

La méthode statique `parse(file)` lit le fichier ligne par ligne. Elle commence par parser les options via `parseOptionLine()`, puis convertit chaque ligne de données en un `DataPoint`. Elle gère les différents formats de données (DB, MA, RI) via la méthode `calculateComplexValue()`, convertit ensuite les paramètres S en impédance grâce à `calculateImpedance()`, et finalement calcule le vrai gamma avec `calculateGammaFromZ()`.

Cette classe permet aussi d'exporter les SWEEPS de fréquence du circuit créer sur l'application en fichier S1P. Les points du sweep sont alors exporté selon de format S MA R (qui sont les paramètres par défaut de ces fichiers).

=== Les calculs mathématiques

Vu que l'abaque de Smith est une projection du plan complexe, il a fallu mettre en place une classe qui gère ces nombres. La classe `Complex` est un record java qui représente un nombre complexe avec sa partie réelle et imaginaire. En plus de cette représentation, elle implémente toutes les opérations nécessaires pour le projet.

Ensuite, une grande partie des calculs mathématiques utilisés pour l'abaque de Smith se trouvent dans la classe `SmithCalculator`. On y trouve les fonctions de conversions d'impédance au coefficient de réflexion et inversement : `gammaToImpedance(gamma, z0)` qui calcule $Z = Z_0 (1 + Gamma)/(1 - Gamma)$ et `impedanceToGamma(z, z0)` qui calcule $Gamma = (Z - Z_0)/(Z + Z_0)$. La classe fournit aussi des méthodes pour calculer le VSWR (Voltage Standing Wave Ratio) via la formule $(1 + |Gamma|)/(1 - |Gamma|)$ et le Return Loss en dB via $-20 log_10(|Gamma|)$ à partir du gamma.

Pour permettre à la vue de dessiner les trajectoires des composants lors de l'ajout à la souris, la méthode `getArcParameters()` détermine le centre et le rayon du cercle que doit suivre le composant sur l'abaque. Le comportement est très différent selon que le composant ajouté est une ligne de transmission ou un composant classique RLC.

*Pour les lignes de transmission en série*, on a deux cas de figure :

Si l'impédance caractéristique de la ligne ajoutée ($Z_L$) est la même que celle du système ($Z_0$), on obtient un centre situé à l'origine de l'abaque $(0, 0)$ et le rayon correspond simplement à la magnitude du coefficient de réflexion du point de départ (cercle de VSWR constant).

Si les impédances caractéristiques diffèrent, il faut trouver le centre décalé du cercle. Pour cela, on calcule d'abord le coefficient de réflexion de l'impédance actuelle par rapport à l'impédance de la Ligne $Z_L$ (et non par rapport à $Z_0$) : $Gamma_"rel" = (Z_"actuelle" - Z_L)/(Z_"actuelle" + Z_L)$. On récupère sa magnitude $rho_L = |Gamma_"rel"|$ qui reste constante lors de la rotation autour de ce cercle.

Ensuite, on détermine les deux points extrêmes du cercle sur l'axe réel (les points de réactance nulle). Ces valeurs sont obtenues via la formule de conversion générale $Z = Z_L frac(1 + Gamma,1 - Gamma)$, simplifiée ici car on se situe sur l'axe réel :

-  Pour l'impédance maximale ($r_max$), le coefficient de réflexion est positif ($Gamma = +rho_L$), ce qui donne la formule : $r_max = Z_L frac(1 + rho_L,1 - rho_L)$.

- Pour l'impédance minimale ($r_min$), le coefficient de réflexion est négatif ($Gamma = -rho_L$), ce qui inverse les signes de l'équation : $r_min = Z_L frac(1 + (-rho_L),1 - (-rho_L)) = Z_L frac(1 - rho_L,1 + rho_L)$.

Ces deux impédances réelles doivent ensuite être converties dans le plan gamma du système $Z_0$ en utilisant la formule du coefficient de réflexion, cette fois ci avec $Z_0$ : $Gamma_"sys min" = (r_"min" - Z_0)/(r_"min" + Z_0)$ et $Gamma_"sys max" = (r_"max" - Z_0)/(r_"max" + Z_0)$.

Le centre du cercle se trouve exactement au milieu de ces deux points : $"centre"_x = (Gamma_"sys min" + Gamma_"sys max")/2$ et le rayon vaut $r = abs(Gamma_"sys max" - Gamma_"sys min") /2$. Ce centre est décalé horizontalement par rapport à l'origine, créant un cercle qui n'est plus centré sur l'abaque mais qui représente correctement la transformation d'impédance par la ligne.

*Pour les lignes en parallèle* c'est bien plus simple. Le cercle est simplement tangent au point $-1, 0$ (qui correspond au court circuit dans le plan des admittance) et au point de départ. Il faut alors trouver le cercle passant par ces deux points. On trouve le centre du cercle en trouvant le point qui est équidistant au court circuit de l'abaque et au $Gamma$ actuel  

#align(center,$"centre"_x = (abs(Gamma)^2 - 1)/(2(1 + Gamma_"réel"))$)

où $Gamma$ est le coefficient de réflexion du point de départ. Le rayon est simplement la distance entre ce centre et le point $(-1, 0)$ : $r = abs("centre"_x - (-1))$.

*Pour les composants RLC classiques*, le comportement est différent selon le type et la position :

- *Résistances* : Elles suivent des cercles de réactance constante (en série) ou de susceptance constante (en parallèle). Le centre en série est $(1, 1/x)$ avec rayon $|1/x|$, où $x$ est la réactance normalisée. En parallèle, le centre est $(-1, -1/b)$ avec rayon $|1/b|$, où $b$ est la susceptance normalisée.

- *Condensateurs et inductances* : Ils suivent des cercles de résistance constante (en série) ou de conductance constante (en parallèle). Le centre en série est $(r/(r+1), 0)$ avec rayon $1/(r+1)$, où $r$ est la résistance normalisée. En parallèle, le centre est $(-g/(g+1), 0)$ avec rayon $1/(g+1)$, où $g$ est la conductance normalisée.

Ces équations sont les équations de base de l'abaque de smith.

Maintenant qu'on peut savoir sur quel cercle, on peut utiliser la fonction `getExpectedDirection(element, previousGamma)` qui calcule la direction (horaire ou anti-horaire) dans laquelle le composant doit se déplacer. C'est très important car par exemple,un condensateur en série tourne dans le sens horaire (réactance négative), une inductance en série dans le sens anti-horaire (réactance positive). Le cercle sur lequel le composant bouge est le même mais la direction change selon le composant.

Finalement il y a la fonction `calculateComponentValue(gamma, ...)` qui convertit une position obtenue de façon graphique (en ajoutant le composant à la souris) en valeur de composant. C'est extrêmement utile car c'est cette valeur qui va ensuite être utilisée pour ajouter le composant au circuit lorsque l'utilisateur va ajouter son composant.

Cette fonction prend en entrée le gamma final (là où la souris est positionnée), l'impédance de départ, le type de composant, sa position (série/parallèle), et d'autres paramètres selon le type d'élément. Elle calcule d'abord l'impédance finale à partir du gamma grâce à la formule $Z = Z_0 (1 + Gamma)/(1 - Gamma)$, puis détermine la valeur du composant selon sa nature.

*Pour les composants RLC classiques*, le calcul diffère selon la position :

- En série, on calcule l'impédance ajoutée $Delta Z = Z_"finale" - Z_"départ"$. Pour une inductance, on utilise $L = "Im"(Delta Z) / omega$. Pour un condensateur, $C = -1/("Im"(Delta Z) dot omega)$ (le signe négatif vient du fait que la réactance capacitive est négative). Pour une résistance, simplement $R = "Re"(Delta Z)$.

- En parallèle, on travaille avec les admittances $Y = 1/Z$. On calcule l'admittance ajoutée $Delta Y = Y_"finale" - Y_"départ"$. Pour une inductance, $L = -1/("Im"(Delta Y) dot omega)$. Pour un condensateur, $C = "Im"(Delta Y)/omega$. Pour une résistance, $R = 1/"Re"(Delta Y)$.

*Pour les lignes de transmission*, c'est plus complexe vu qu'il faut calculer la longueur physique de la ligne :

- Pour une ligne série (sans stub), on doit pouvoir savoir combien de fois on a fait le tour du cercle déterminé par `getArcParameters()` sur l'abaque. Initialement on calculait la formule de propagation de la réflexion ($Gamma(L) = Gamma(0) dot e^(-j 2 beta L)$) pour pouvoir trouver l'angle de rotation et ensuite trouver la longueur de la ligne. Mais finalement, la partie graphique de l'application est au courant de l'angle de rotation vu qu'on utilise cette valeur pour pouvoir borner le mouvement de l'utilisateur. Il suffit alors de donner cette valeur à la fonction et de calculer la longueur de la ligne comme $L = frac("angle",2 dot beta)$. Si cette information n'est pas disponible (par exemple lors d'une modification manuelle), on recalcule l'angle à partir des gammas de départ et d'arrivée transformés dans le référentiel de la ligne ($Z_L$), puis on applique la même formule.

- Pour les stubs (court-circuit ou circuit ouvert), on travaille avec l'abaque d'admittance. Un stub court-circuité donne $Y_"in" = -j Y_0 / tan(beta L)$, donc on résout $tan(beta L) = -Y_0 / B$ où $B$ est la susceptance cible, ce qui donne $L = arctan(-Y_0 / B) / beta$. Pour un stub ouvert, $Y_"in" = j Y_0 tan(beta L)$, donc $tan(beta L) = B / Y_0$ et $L = arctan(B / Y_0) / beta$. On s'assure ensuite que la longueur est positive en ajoutant des multiples de $pi/beta$ si nécessaire.

La fonction renvoie `null` si le calcul est impossible (division par zéro, valeur négative ou non-finie), garantissant ainsi que seules des valeurs physiquement réalistes sont retournées. Et si une telle valeur est retournée, l'opération d'ajout de composant est ignorée.


=== Gestion des "undo/redo"

Comme tout bon programme informatique, il est très utile de revenir sur ce qu'on a pu faire. Pour cela, deux systèmes ont été mis en place. 

Un système générique `HistoryManager` qui permet d'avoir une gestion de deux piles génériques. Une pile de redo et une pile de undo. Lorsqu'on consomme une action undo, l'état actuel est sauvegardé dans la pile de redo, puis l'état précédent est restauré depuis la pile d'undo. Inversement, lorsqu'on fait un redo, l'état actuel est remis dans la pile d'undo et l'état suivant est récupéré depuis la pile de redo.

Ensuite pour pouvoir utiliser ce gestionnaire, un record `UndoRedoEntry` a été mis en place qui garde comme information l'opération effectuée (ADD, REMOVE, MODIFY), l'index du circuit modifié ainsi qu'une paire d'élément qui lie l'élément du circuit subissant l'opération et son index dans le circuit choisi. Ensuite selon ce que l'utilisateur fait, chaque action est gardée dans le manager et l'utilisateur peut a choix revenir sur ce qu'il a fait! Le viewModel lui s'occupe de reconstruire le circuit à chaque undo/redo.


=== Les composants discrets

Dans le monde réel, les composants ne peuvent pas prendre n'importe quelle valeur. Ils existent en séries normalisées (séries E12, E24, E96, etc.) et il est pratique de pouvoir visualiser directement les valeurs des composants qu'on a sous la main, plutôt que des valeurs théoriques idéales.

L'utilisateur peut créer sa propre bibliothèque de composants disponibles via une fenêtre de dialogue (`DiscreteComponentConfigDialog`). Cette fenêtre permet d'ajouter des composants avec leur valeur exacte et leurs caractéristiques parasites, soit en utilisant le facteur de qualité, soit sous forme d'ESR. Dépendamment du constructeur du composant et de son type, les datasheets mettent à disposition soit l'un, soit l'autre (ou les deux).

Une nouvelle classe `ComponentEntry` a été mise en place pour encapsuler ces informations et pour pouvoir facilement les utiliser et aussi les exporter. L'utilisateur peut alors exporter ou importer des fichiers CSV contenant les informations nécessaires à cette bibliothèque de composants.

Ensuite, lorsque le mode "composants discrets" est activé par l'utilisateur, le comportement de l'ajout à la souris change. L'utilisateur peut toujours bouger sa souris comme il le souhaite, mais la valeur du composant calculé et son affichage se bloquent sur les valeurs des composants discrets en utilisant la méthode `getClosestComponentEntry()`. Cette méthode parcourt tous les composants du type sélectionné et trouve celui dont la valeur est la plus proche de la valeur calculée à la position actuelle de la souris. De plus, l'affichage de l'abaque rajoute des points directement sur l'abaque pour que l'utilisateur puisse voir où sont positionnés ces composants discrets.

=== Le management du projet

Pour pouvoir sauvegarder l'état du projet sur lequel on travaille, il fallait mettre en place un moyen de sérialiser les informations et de les exporter dans un fichier. Le choix a été fait de ne pas garder en mémoire les fichiers S1P importés lors de la sauvegarde, ni les sweeps effectués, ni la configuration des composants discrets. Chacun peut être exporté de son côté.

Les éléments sauvegardés, stockés dans un record agissant comme DTO (Data Transfer Object), sont le nom du projet, la fréquence de travail, l'impédance caractéristique du système ($Z_0$), l'impédance de charge, et surtout tous les circuits créés par l'utilisateur (stockés sous forme de liste de listes de `CircuitElement`).

La classe `ProjectManager` s'occupe de la sérialisation et désérialisation des projets. Elle utilise la bibliothèque Jackson pour convertir les données en format JSON avec le module `Jdk8Module` pour gérer correctement les types Java modernes (comme `Optional`). 

Lors de la sauvegarde du projet via la méthode `saveProject()`, le logiciel vérifie si le projet est déjà associé à un fichier. Si non, un dialogue de sélection demande à l'utilisateur de choisir un emplacement où stocker le fichier (avec l'extension `.jsmfx`). Ensuite, le chemin du fichier est sauvegardé dans la classe et toutes les sauvegardes ultérieures se feront automatiquement sur ce même fichier. Une option "Save As" existe aussi pour pouvoir sauvegarder dans un nouveau fichier même si le projet est déjà lié à un fichier existant.

Lors du chargement via `loadProject()`, le fichier JSON est désérialisé et toutes les propriétés du ViewModel sont restaurées. Une fois le chargement terminé, les flags `hasBeenSaved` et `isModified` sont mis à jour pour refléter l'état du projet. Ces flags sont mis à jour à chaque interaction que l'utilisateur a avec l'abaque pour indiquer si le projet a eu des changements depuis la dernière sauvegarde. 

Finalement, si des changements ont eu lieu mais qu'aucune sauvegarde n'a été effectué lorsque l'utilisateur souhaite quitter l'application, on demande à l'utilisateur s'il est sûr de vouloir quitter. Un comportement classique de ce genre d'application.

== Partie ViewModel

Le ViewModel est la partie qui contient l'état de l'application, c'est la mémoire, mais aussi le cerveau. C'est lui qui s'occupe de mettre à jour les valeurs et de recalculer la chaîne d'impédance lorsqu'on modifie le circuit. La classe `SmithChartViewModel` agit comme l'unique source de vérité pour l'état de l'application et quasiment toutes les autres classes dépendent d'elle pour le comportement de l'abaque.

=== Les JavaFX Properties

JavaFX met à disposition des classes spéciales, les *JavaFX Properties*. Elles sont intrinsèquement observables, ce qui veut dire qu'on peut réagir dès qu'elles sont modifiées. Les différentes classes mettent en place des "listeners" qui déclenchent une interaction des qu'une valeur change. Ou bien on peut aussi mettre en place des méthodes qui lient des éléments d'interfaces à des valeurs dans le viewModel.

Le ViewModel est constitué de plusieurs catégories de propriétés :

*Les propriétés physiques du système* : Ce sont les paramètres "principaux" de l'abaque de Smith. On trouve l'impédance caractéristique du système (`zo`, généralement 50Ω), l'impédance de charge au départ de la chaîne (`loadImpedance`) et la fréquence du système (`frequency`). Chacune de ces propriétés est observée, et toute modification déclenche automatiquement un recalcul complet de la chaîne d'impédance.

*Les collections de données* : Le ViewModel gère plusieurs listes observables (`ObservableList`) qui stockent les différents types de points affichés sur l'abaque. Les `dataPoints` contiennent les points du circuit principal (l'impédance cumulée à chaque étape). Les `s1pDataPoints` stockent les données importées depuis un fichier S1P, et les `transformedS1PPoints` représentent ces mêmes points après transformation par les composants du circuit. Les `sweepDataPoints` contiennent les résultats d'un balayage en fréquence. Finalement, une liste `combinedDataPoints` agrège tous ces points pour faciliter le rendu graphique.

*Les propriétés d'interaction utilisateur* : Pour afficher les informations en temps réel lors du survol de l'abaque avec la souris, le ViewModel maintient des propriétés comme `mouseGamma`, `mouseImpedanceZ`, `mouseAdmittanceY`, `mouseVSWR`, `mouseReturnLoss` et `mouseQualityFactor`. Ces valeurs sont calculées instantanément lorsque la souris se déplace sur l'abaque et sont affichées dans l'interface via un binding.

*Les propriétés d'état de l'application* : Le ViewModel garde également la trace de l'état global, tel que le nom du projet (`projectName`), si le projet a été sauvegardé (`hasBeenSaved`), s'il a été modifié (`isModified`), ou encore si l'utilisateur est en train de modifier un composant (`isModifyingComponent`). Un flag `isRedrawing` permet d'éviter les redessins redondants via le mécanisme de debouncing expliqué précédemment.

=== Le recalcul des éléments de l'abaque

Dès que l'utilisateur modifie un paramètre du système (fréquence, impédance de charge, impédance caractéristique) ou ajoute, retire ou encore modifie un composant du circuit, un recalcul complet de la chaîne d'impédance est nécessaire. La méthode `recalculateImpedanceChain()` est alors appelée sur le ViewModel. Cette méthode délègue le calcul au service `CircuitSimulator`, qui se charge de la simulation proprement dite. J'ai essayé de développer une fonction qui recalcule la chaîne d'impédance de façon intelligente, mais ce calcul est si rapide qu'il n'est pas très utile d'essayer d'optimiser cela et de rajouter de la complexité programmatique.
Le `CircuitSimulator` parcourt séquentiellement tous les éléments du circuit en partant de l'impédance de charge. Pour chaque élément, il calcule la transformation d'impédance via la méthode `propagateOne()`. Cette méthode prend la dernière impédance calculée et, selon le type de composant ajouté, calcule l'impédance qui suit en la rajoutant à l'impédance actuelle.

À chaque étape de la propagation, un nouveau `DataPoint` est créé et rajouté à la liste qui sera retournée au ViewModel à la fin de l'exécution de la fonction. 

Ce même service `CircuitSimulator` est également utilisé pour la transformation des points S1P à travers le circuit d'adaptation (via `calculateTransformedS1P()`) et les balayages en fréquence (via `performSweep()`). La logique de propagation reste la même, seules les données d'entrée et la manière de les itérer diffèrent.

=== Gestion de plusieurs circuits

L'application permet de gérer plusieurs circuits pour le même système de base, c'est une fonctionnalité qui a été rajoutée sur la fin du projet. La manière dont elle a été conçue fait en sorte que le système en lui-même ne soit pas au courant qu'il travaille sur plusieurs circuits. Lorsque l'utilisateur le choisit, le ViewModel change simplement de circuit principal.

Le ViewModel gère une liste observable `allCircuits` qui contient plusieurs `ObservableList<CircuitElement>`, chaque liste représentant un circuit distinct. Une propriété `circuitElementIndex` indique quel circuit est actuellement actif. La propriété `circuitElements` est alors liée dynamiquement au circuit actif via un binding JavaFX `circuitElements.bind(Bindings.valueAt(allCircuits, circuitElementIndex))`.

Ce binding va alors changer dynamiquement la référence sur le circuit actif et, vu que le circuit change, le viewModel va lancer un calcul complet de tous les éléments. On sépare complètement la notion de plusieurs circuits du calcul et de l'affichage de l'abaque. La vue et tous les éléments liés aux calculs ne voient que le circuit actif. 


=== Utilisation du pattern Singleton

Dans la logique de l'application, il ne doit y avoir qu'un seul ViewModel vu que c'est, comme dit plus tôt, l'unique source de vérité. Pour imposer cet aspect, l'utilisation d'un pattern Singleton était nécessaire. Il était aussi utile, dans certaines classes, de pouvoir simplement accéder à l'état de l'application avec un simple `SmithChartViewModel.getInstance()`, cela évite de devoir passer l'objet en référence directement.

On utilise aussi ce pattern pour la fenêtre du graphe MagLog pour les fichiers S1P. 


