= Implémentation

L'implémentation du projet est totale, toutes les demandes du cahier des charges ont pu être mises en place. JSmithFX permet de correctement afficher un abaque de Smith et d'interagir avec pour créer des circuits d'adaptation d'impédance.

#figure(image("../images/overview_general_JSmithFX.png",width:100%), caption : "Vue d'ensemble de l'application finale")

L'interface a été pensée pour être moderne (basée sur le thème Nord Dark d'AtlantaFX) et réactive. Voici une énumération des fonctionnalités implémentées dans cette version finale :

- *Modélisation complète des composants* : Ajout de composants RLC (avec gestion du facteur de qualité Q et des pertes) en série et en parallèle, ainsi que des lignes de transmission et des stubs (ouverts et court-circuités).
- *Affichage Abaque-Circuit* : Affichage simultané et synchronisé de l'abaque de Smith et du schéma électrique du circuit généré par l'ajout de composants par l'utilisateur. 
- *Interactions* :
    - Ajout de composants à la souris avec magnétisation de celle-ci sur les trajectoires physiques des composants.
    - Système d'Undo/Redo (CTRL+Z / CTRL+Y).
    - Navigation fluide sur l'abaque (zoom, pan).
- *Analyse et Simulation* :
    - Calcul en temps réel des valeurs importantes pour la radio fréquence (VSWR, Return Loss, Gamma, Impédance).
    - Balayage en fréquence (Sweep) sur le circuit avec visualisation de la courbe de réponse directement sur l'abaque.
    - Modification dynamique de la valeur d'un composant sélectionné via des sliders (Fine Tuning).
- *Gestion de données S1P* :
    - Importation de fichiers Touchstone (.s1p).
    - Visualisation des données S1P sur l'abaque avec filtrage par plages de fréquences.
    - Fenêtre dédiée pour visualiser les graphiques de Magnitude/Fréquence des fichiers importés.
    - Utilisation d'un point S1P comme impédance de charge.
- *Composants Discrets* : Système de bibliothèque permettant de forcer l'utilisation de valeurs normalisées (séries E12, E24, etc.) lors de la conception.
- *Gestion de projet* : Sauvegarde et chargement de l'état complet de l'application via des fichiers `.jsmfx` (JSON), et gestion de plusieurs circuits au sein d'un même projet.

On obtient alors un logiciel complet et utilisable pour effectuer des adaptations d'impédance.

== Déploiement
Pour déployer l'application de façon multiplateforme, deux choix s'offrent à nous. Soit on construit une image `.jar` (un *UberJar* plus précisément, en utilisant l'outil Gradle `ShadowJar`, qui est tout simplement un jar qui contient toutes les dépendances nécessaires par le programme, obligatoire ici vu l'utilisation de JavaFX) qui permet de lancer l'application n'importe où, là où la JVM est installée. Soit on génère une application propre à chaque plateforme que l'utilisateur télécharge selon son système.

Le point fort de la seconde méthode est qu'on n'oblige pas l'utilisateur à avoir Java installé sur son appareil, mais on perd la portabilité du `.jar`.

Mon choix se porte alors sur un déploiement utilisant les outils de CI/CD de GitHub pour proposer la solution portable avec l'utilisation du `ShadowJar`.

== Logique du contrôleur d'interaction

=== Gestion du redessin (Debouncing)

Dès qu'une action touchant à l'abaque est réalisée, le `SmithChartInteractionController` appelle la fonction `redrawSmithCanvas`. Dans la version 1.0 de ce projet, cette fonction est sollicitée à de très nombreux endroits (plus de 30 fois). Elle demande ensuite au `SmithChartRenderer` de redessiner l'abaque entièrement.

Pour éviter de surcharger le processeur avec des calculs inutiles (par exemple lors d'un redimensionnement rapide de la fenêtre ou d'un mouvement de souris), un mécanisme d'anti-rebond a été mis en place. L'opération active un flag sur le ViewModel, nommé `isRedrawing`.

L'opération de dessin est ensuite déléguée au thread d'application via la fonction JavaFX `Platform.runLater`. Si une nouvelle demande de dessin arrive alors que le flag est encore à `true`, elle est ignorée. Une fois le dessin terminé, le drapeau repasse à `false`. Cette optimisation permet d'éliminer énormément de demandes de dessin superflues et d'éviter des ralentissements de l'interface utilisateur.

=== Magnétisation de la souris

Le contrôleur gère la fonctionnalité extrêmement importante d'ajout à la souris (`handleMouseMagnetization`). Lorsqu'un utilisateur ajoute un composant visuellement, le curseur ne se déplace pas librement, il doit se magnétiser au comportement souhaité du composant qu'on ajoute. Par exemple, un condensateur en parallèle va suivre un cercle de conductance constante et afficher en temps réel l'effet qu'a le composant sur le circuit d'adaptation.

Le système projette le mouvement de la souris sur le vecteur tangent au cercle, convertit ce déplacement linéaire en changement d'angle, puis recalcule la valeur du composant à chaque mouvement. Pour les lignes de transmission, le système permet une rotation infinie autour du cercle, tandis que, pour les autres composants, l'angle est borné entre le point de départ et les limites physiques (circuit ouvert ou court-circuit).

=== Curseur Virtuel et Wayland

Au début du projet, le mécanisme de magnétisation de la souris déplaçait directement le curseur de l'utilisateur à l'aide de la classe `Robot` de JavaFX. Cependant, lors de tests sur une machine Linux, un problème est apparu. Pour des raisons de sécurité de la plateforme Wayland#footnote("Documentation du \"bug\" https://bugs.openjdk.org/browse/JDK-8307779)"), le système d'exploitation empêchait le déplacement programmatique de la souris. Cette fonctionnalité était donc inutilisable sur certaines plateformes.

Pour résoudre ce problème, il a fallu mettre en place un système de curseur virtuel basé sur deux Canvas superposés. L'un est le `smithCanvas`, le canvas principal qui contient l'abaque de Smith, les tracés d'impédance et les points de données. Ensuite, la nouveauté, le `cursorCanvas`, un canvas transparent superposé au premier, dédié aux éléments interactifs temporaires (curseur virtuel, tooltips).

Lors de l'ajout d'un composant à la souris, un curseur virtuel est affiché sur le `cursorCanvas` à la position magnétisée correcte. La classe `Robot` est tout de même instanciée et tente de déplacer le curseur système pour garder la souris synchronisée avec le mouvement magnétisé. Mais si le système d'exploitation bloque cette opération, le curseur virtuel agit comme mécanisme de repli pour garantir que l'utilisateur voit toujours la position correcte. 
Cette solution, basée sur deux Canvas, reste valide même si ce problème lié à Wayland est corrigé dans une version future de JavaFX. Elle fonctionne de manière uniforme, peu importe la plateforme sur laquelle l'application tourne.

=== Schéma du circuit

Pour construire le schéma du circuit, la méthode `render()` du `CircuitRenderer` boucle sur tous les éléments du circuit actif contenu dans le viewModel. Ensuite, pour chaque élément, dépendamment du type, la méthode les dessine de la façon la plus simple possible en suivant le style de la norme IEC.

En parallèle du dessin, le renderer construit deux systèmes de hitbox pour permettre l'interaction avec l'utilisateur. Les hitboxes sont des zones rectangulaires invisibles qui détectent si la souris se trouve dedans, ce sont des zones cliquables.

Pour chaque composant dessiné, la méthode `registerHitBox()` crée une zone de détection et la stocke dans une `Map<CircuitElement, Rectangle2D>`. Cette map associe chaque élément du circuit à sa zone cliquable. Quand l'utilisateur clique quelque part, la méthode `getElementAt(x, y)` parcourt toutes ces hitboxes et retourne l'élément qui a été cliqué (ou `null` si on a cliqué dans le vide). Le système est exactement le même avec les points d'insertion, sauf qu'on utilise la méthode `getInsertionIndexAt(x,y)` qui retourne l'index d'insertion (ou `-1` si on a cliqué dans le vide).

Ces méthodes sont ensuite appelées dans le `MainController` qui, à chaque clic sur le schéma électrique du circuit (avec la fonction de JavaFX `circuitCanvas.setOnMouseClicked`), recherche si ce clic était oui ou non sur un élément cliquable ou sur un point d'insertion.

==== Modification des composants

Lorsqu'on clique sur un composant, on le sélectionne grâce à la fonction `selectElement()` et on affiche le panneau de fine-tuning, permettant d'ajuster sa valeur en temps réel et, si disponible, son facteur de qualité via des sliders. Ce clic change aussi la fenêtre d'ajout de composant en une fenêtre de modification du composant sélectionné.

Lorsqu'un composant est sélectionné via `selectElement()`, une copie de son état est immédiatement sauvegardée dans une variable nommée `originalElement` se trouvant dans le viewModel. Les modifications sont alors appliquées directement sur le composant actif, permettant une prévisualisation en temps réel sur l'abaque sans devoir grandement changer le code. Si l'utilisateur valide les changements, la copie est supprimée et le composant modifié est conservé. Si l'utilisateur annule l'opération en cliquant sur le bouton ESC, le `MainController` appelle la méthode `cancelTuningAdjustments()`, le composant modifié est alors restauré à son état d'origine grâce à la copie sauvegardée.

== Calculs Mathématiques et Physique

Vu que l'abaque de Smith est une projection du plan complexe, il a fallu mettre en place une classe qui gère ces nombres. La classe `Complex` est un record Java qui représente un nombre complexe avec sa partie réelle et imaginaire. En plus de cette représentation, elle implémente toutes les opérations nécessaires pour le projet. Un point important de cette classe est la gestion des cas limites mathématiques. Tout ce qui concerne la division par zéro, les valeurs infinies et les opérations avec des nombres non finis est géré.

Ensuite, une grande partie des calculs mathématiques utilisés pour l'abaque de Smith se trouvent dans la classe `SmithCalculator`. On y trouve les fonctions de conversions d'impédance au coefficient de réflexion et inversement : `gammaToImpedance(gamma, z0)` qui calcule $Z = Z_0 (1 + Gamma)/(1 - Gamma)$ et `impedanceToGamma(z, z0)` qui calcule $Gamma = (Z - Z_0)/(Z + Z_0)$. La classe fournit aussi des méthodes pour calculer le VSWR (Voltage Standing Wave Ratio) via la formule $(1 + |Gamma|)/(1 - |Gamma|)$ et le Return Loss en dB via $-20 log_10(|Gamma|)$ à partir du gamma.

=== Facteur de qualité

Un facteur de qualité (Q) a été mis en place pour les condensateurs et les inducteurs qui permet d'avoir des simulations de circuit d'adaptation plus réalistes. Ce facteur induit une résistance parasite aussi appelée ESR (Equivalent Serie Resistance) @cours_circuits_resonants:

- En série, on calcule une résistance de perte $"Rs" = abs(X)/Q$.

- En parallèle, on calcule une résistance de perte $"Rp" = abs(X) dot Q$.

Puisque la réactance (X) d'un condensateur est négative, on utilise sa valeur absolue pour garantir une résistance toujours positive. Selon la configuration choisie, cette résistance est combinée à la réactance pure pour former l'impédance réelle du composant.

Ce même champ "facteur de qualité" est réutilisé pour les lignes de transmission, mais, avec une signification différente, il modélise les pertes exprimées en dB/m. Ce choix peut sembler un peu bizarre (réutiliser une variable pour une unité physique différente), mais il a été fait par souci de simplicité dans le modèle de données. Il était aussi voulu d'essayer de garder la logique des interactions dans le code, ces interactions étant les mêmes entre le facteur de qualité des composants classiques et les pertes des lignes de transmission. Plus d'explication sur son utilisation plus bas dans la section "Calcul de la valeur des composants".

=== Calcul des arcs graphiques

Pour permettre à la vue de dessiner les trajectoires des composants lors de l'ajout à la souris, la méthode `getArcParameters()` détermine le centre et le rayon du cercle que doit suivre le composant sur l'abaque. Le comportement est très différent selon que le composant ajouté est une ligne de transmission ou un composant classique RLC.

*Pour les lignes de transmission en série*, on a deux cas de figure :

Si l'impédance caractéristique de la ligne ajoutée ($Z_L$) est la même que celle du système ($Z_0$), on obtient un centre situé à l'origine de l'abaque $(0, 0)$ et le rayon correspond simplement à la magnitude du coefficient de réflexion du point de départ (cercle de VSWR constant).

Si les impédances caractéristiques diffèrent, il faut trouver le centre décalé du cercle. Pour cela, on calcule d'abord le coefficient de réflexion de l'impédance actuelle par rapport à l'impédance de la Ligne $Z_L$ (et non par rapport à $Z_0$) : $Gamma_"rel" = (Z_"actuelle" - Z_L)/(Z_"actuelle" + Z_L)$. On récupère sa magnitude $rho_L = |Gamma_"rel"|$ qui reste constante lors de la rotation autour de ce cercle.

Ensuite, on détermine les deux points extrêmes du cercle sur l'axe réel (les points de réactance nulle). Ces valeurs sont obtenues via la formule de conversion générale $Z = Z_L frac(1 + Gamma,1 - Gamma)$, simplifiée ici, car on se situe sur l'axe réel :

-  Pour l'impédance maximale ($r_max$), le coefficient de réflexion est positif ($Gamma = +rho_L$), ce qui donne la formule : $r_max = Z_L frac(1 + rho_L,1 - rho_L)$.

- Pour l'impédance minimale ($r_min$), le coefficient de réflexion est négatif ($Gamma = -rho_L$), ce qui inverse les signes de l'équation : $r_min = Z_L frac(1 + (-rho_L),1 - (-rho_L)) = Z_L frac(1 - rho_L,1 + rho_L)$.

Ces deux impédances réelles doivent ensuite être converties dans le plan gamma du système $Z_0$ en utilisant la formule du coefficient de réflexion, cette fois ci avec $Z_0$ : $Gamma_"sys min" = (r_"min" - Z_0)/(r_"min" + Z_0)$ et $Gamma_"sys max" = (r_"max" - Z_0)/(r_"max" + Z_0)$.

Le centre du cercle se trouve exactement au milieu de ces deux points : $"centre"_x = (Gamma_"sys min" + Gamma_"sys max")/2$ et le rayon vaut $r = abs(Gamma_"sys max" - Gamma_"sys min") /2$. Ce centre est décalé horizontalement par rapport à l'origine, créant un cercle qui n'est plus centré sur l'abaque, mais qui représente correctement la transformation d'impédance par la ligne.

*Pour les stubs* (lignes en configuration shunt) c'est bien plus simple. Le cercle est simplement tangent au point $-1, 0$ (qui correspond au court-circuit dans le plan des admittances) et au point de départ. Il faut alors trouver le cercle passant par ces deux points. On trouve le centre du cercle en trouvant le point qui est équidistant au court-circuit de l'abaque, au $Gamma$ actuel et qui se trouve sur l'axe $Y = 0$ de l'abaque

#align(center,$"centre"_x = (abs(Gamma)^2 - 1)/(2(1 + Gamma_"réel"))$)

où $Gamma$ est le coefficient de réflexion du point de départ. Le rayon est simplement la distance entre ce centre et le point $(-1, 0)$ : $r = abs("centre"_x - (-1))$.

*Pour les composants RLC classiques*, le comportement est différent selon le type et la position :

- *Résistances* : Elles suivent des cercles de réactance constante (en série) ou de susceptance constante (en parallèle). Le centre en série est $(1, 1/x)$ avec rayon $|1/x|$, où $x$ est la réactance normalisée. En parallèle, le centre est $(-1, -1/b)$ avec rayon $|1/b|$, où $b$ est la susceptance normalisée.

- *Condensateurs et inductances* : Ils suivent des cercles de résistance constante (en série) ou de conductance constante (en parallèle). Le centre en série est $(r/(r+1), 0)$ avec rayon $1/(r+1)$, où $r$ est la résistance normalisée. En parallèle, le centre est $(-g/(g+1), 0)$ avec rayon $1/(g+1)$, où $g$ est la conductance normalisée.

Ces équations sont les équations de base de l'abaque de Smith.

Maintenant qu'on peut savoir sur quel cercle le composant va agir, on peut utiliser la fonction `getExpectedDirection(element, previousGamma)` qui calcule la direction (horaire ou antihoraire) dans laquelle le composant doit se déplacer. C'est très important, car, par exemple, un condensateur en série tourne dans le sens horaire (réactance négative), une inductance en série dans le sens antihoraire (réactance positive). Le cercle sur lequel le composant bouge est le même, mais la direction change selon le composant.

=== Dessins des arcs des composants non parfaits

Le problème avec les composants imparfaits (ceux qui possèdent un facteur de qualité non infini) est qu'ils ne suivent pas un cercle constant sur l'abaque de Smith. La présence de pertes modifie progressivement l'impédance le long du trajet, créant une spirale se rapprochant du centre de l'abaque plutôt qu'un arc de cercle parfait.

Pour résoudre ce problème, la méthode `getLossyComponentPath` de la classe `SmithCalculator` génère 200 points qui représentent le chemin progressif de l'impédance transformée par le composant avec pertes. Ce nombre s'est avéré suffisant lors des tests, bien qu'un problème de résolution apparaisse avec des composants s'approchant de valeurs extrêmes (près des extrémités -1,0 et 1,0 de l'abaque).

Ensuite le principe est simple, on subdivise le composant en 200 sous-composants, on calcule le coefficient de réflexion pour chacun d'eux, puis on relie ces points avec la fonction `strokePolyline` de JavaFX pour obtenir la trajectoire complète.

=== Calcul de la valeur des composants

Finalement il y a la fonction `calculateComponentValue(gamma, ...)` qui convertit une position obtenue de façon graphique (en ajoutant le composant à la souris) en valeur de composant. C'est extrêmement utile, car c'est cette valeur qui va ensuite être utilisée pour ajouter le composant au circuit lorsque l'utilisateur va ajouter son composant.

Cette fonction prend en entrée le gamma final (là où la souris est positionnée), l'impédance de départ, le type de composant, sa position (série/parallèle), et d'autres paramètres selon le type d'élément. Elle calcule d'abord l'impédance finale à partir du gamma grâce à la formule $Z = Z_0 (1 + Gamma)/(1 - Gamma)$, puis détermine la valeur du composant selon sa nature.

*Pour les composants RLC classiques*, le calcul diffère selon la position :

- En série, on calcule l'impédance ajoutée $Delta Z = Z_"finale" - Z_"départ"$. Pour une inductance, on utilise $L = "Im"(Delta Z) / omega$. Pour un condensateur, $C = -1/("Im"(Delta Z) dot omega)$ (le signe négatif vient du fait que la réactance capacitive est négative). Pour une résistance, simplement $R = "Re"(Delta Z)$.

- En parallèle, on travaille avec les admittances $Y = 1/Z$. On calcule l'admittance ajoutée $Delta Y = Y_"finale" - Y_"départ"$. Pour une inductance, $L = -1/("Im"(Delta Y) dot omega)$. Pour un condensateur, $C = "Im"(Delta Y)/omega$. Pour une résistance, $R = 1/"Re"(Delta Y)$.

*Pour les lignes de transmission*, c'est plus complexe vu qu'il faut calculer la longueur physique de la ligne :

- Pour une ligne série (sans stub), on doit pouvoir savoir combien de fois on a fait le tour du cercle déterminé par `getArcParameters()` sur l'abaque. Initialement on calculait la formule de propagation de la réflexion ($Gamma(L) = Gamma(0) dot e^(-j 2 beta L)$) pour pouvoir trouver l'angle de rotation et ensuite trouver la longueur de la ligne. Mais finalement, la partie graphique de l'application est au courant de l'angle de rotation vu qu'on utilise cette valeur pour pouvoir borner le mouvement de l'utilisateur. Il suffit alors de donner cette valeur à la fonction et de calculer la longueur de la ligne comme $L = frac("angle",2 dot beta)$. Si cette information n'est pas disponible (par exemple lors d'une modification manuelle), on recalcule l'angle à partir des gammas de départ et d'arrivée transformés dans le référentiel de la ligne ($Z_L$), puis on applique la même formule.

- Pour les stubs (court-circuit ou circuit ouvert), on travaille avec l'abaque d'admittance. Un stub court-circuité donne $Y_"in" = -j Y_0 / tan(beta L)$, donc on résout $tan(beta L) = -Y_0 / B$ où $B$ est la susceptance cible.

    Ce qui donne $L = arctan(-Y_0 / B) / beta$. Pour un stub ouvert, $Y_"in" = j Y_0 tan(beta L)$, donc $tan(beta L) = B / Y_0$ et $L = arctan(B / Y_0) / beta$. On s'assure ensuite que la longueur est positive en ajoutant des multiples de $pi/beta$ si nécessaire.

La fonction renvoie `null` si le calcul est impossible (division par zéro, valeur négative ou non-finie), garantissant ainsi que seules des valeurs physiquement réalistes sont retournées. Et si une telle valeur est retournée, l'opération d'ajout de composant est ignorée.

Dans la vue, cette valeur est mise à jour en temps réel à chaque mouvement de la souris lors de l'ajout d'un composant. Pour les lignes de transmission, un binding bidirectionnel a été mis en place entre la longueur physique de la ligne et sa longueur électrique (exprimée en $lambda$, la longueur d'onde). 

=== La chaîne de calcul d'impédance

C'est le cœur de l'application. La méthode `recalculateImpedanceChain()`, comme son nom l'indique, calcule l'état du circuit actuel pour que la vue puisse ensuite afficher les éléments sur l'abaque de façon correcte.

On part de l'impédance de charge et on itère ensuite sur la liste des différents éléments qui constituent notre circuit. Pour chaque composant, on prend l'impédance calculée au composant précédent (ou bien si c'est le premier composant de la chaîne, on regarde l'impédance de la charge) et on calcule la nouvelle impédance en ajoutant le composant qu'on traite actuellement.

On fait cela jusqu'à ce que tous les éléments soient traités. Pour pouvoir avoir un affichage correct de toutes les étapes sur l'abaque, deux listes sont mises à jour, la liste `dataPoints` (pour le tableau de valeurs) et la liste `measuresGamma` (pour le dessin sur l'abaque).

=== Lignes de transmission (formules générales)

*Pour une ligne série* (sans stub), on utilise la formule de transformation d'impédance @cours_milieu_cablés @ligne_transmission_wikipedia :

$ Z_"in" = Z_0 (Z_L + Z_0 tanh(gamma l))/(Z_0 + Z_L tanh(gamma l)) $

où $gamma = alpha + j beta$ est l'exposant de propagation (qui prend en compte les pertes via le facteur de qualité réutilisé comme perte en dB/m, ici $alpha$), et $beta = (2 pi f)/c sqrt(epsilon_r)$ est la constante de phase.

*Pour les stubs* (court-circuit ou circuit ouvert), on part de la même formule générale avec pertes, mais avec des charges particulières. Pour un stub court-circuité ($Z_L = 0$), on obtient :

$ Z_"in" = Z_0 (0 + Z_0 tanh(gamma L))/(Z_0 + 0) = Z_0 tanh(gamma L) $

qu'on convertit en admittance : $Y_"in" = Y_0 / tanh(gamma L)$. Pour un stub ouvert ($Z_L -> infinity$), on divise numérateur et dénominateur par $Z_L$ et on effectue le calcul de limite, ce qui donne :

$ Z_"in" = Z_0 / tanh(gamma L) $

soit en admittance : $Y_"in" = Y_0 tanh(gamma L)$. Ces admittances sont ensuite ajoutées en parallèle au circuit. Finalement, pour déterminer la longueur du stub à partir de la susceptance cible $B$, on résout $tan(beta L) = -Y_0 / B$ pour un stub court-circuité, et $tan(beta L) = B / Y_0$ pour un stub ouvert.

== Dessin de l'abaque

Le rendu est géré par la classe `SmithChartRenderer` et se décompose en trois étapes successives, réexécutées à chaque redimensionnement de la fenêtre ou modification des données.

=== L'abaque lui-même

La méthode `drawSmithGrid` dessine les cercles de résistance et de conductance constantes, ainsi que les arcs de réactance et de susceptance. Pour ce faire, elle itère sur une liste de valeurs prédéfinies (0.2, 0.5, 1.0, 2.0, 4.0, 10.0), ce sont les mêmes valeurs prédéfinies que propose Smith.exe par ailleurs.

Une astuce technique utilisée ici est l'utilisation du clipping (`gc.clip()`). Plutôt que de calculer mathématiquement les intersections exactes des arcs avec le cercle extérieur, on dessine des cercles complets, et on demande au contexte graphique de masquer tout ce qui dépasse du rayon principal de l'abaque.

=== Les points d'impédance

La méthode `drawImpedancePoints` récupère la liste des coefficients de réflexion ($Gamma$) calculés par le ViewModel. Comme le plan complexe de l'abaque de Smith correspond directement aux coordonnées cartésiennes du coefficient de réflexion, la projection sur l'écran est directe, la partie réelle de $Gamma$ devient la coordonnée X et la partie imaginaire la coordonnée Y, le tout mis à l'échelle par le rayon du cercle.

=== Le tracé du circuit d'impédance

Après avoir dessiné les points d'impédance de chaque élément constituant le circuit, il reste la partie la plus complexe, relier ces points entre eux en respectant la physique de l'abaque. Ce chemin est généré par la fonction `drawImpedancePath`.

Contrairement à un graphique classique, on ne relie pas les points par des lignes droites. Le déplacement d'un point à un autre, suite à l'ajout d'un composant, suit toujours une trajectoire courbe spécifique (cercle de résistance constante pour une réactance série par exemple).

Pour dessiner cela, l'algorithme calcule d'abord le centre et le rayon du cercle de mouvement. Ensuite, il détermine l'angle de départ et l'angle d'arrivée. Enfin, il vérifie dans quelle direction tracer l'arc (horaire ou antihoraire) selon la nature du composant (résistance, condensateur, etc.) et sa position dans le circuit. Finalement on réutilise le même système que pour la magnétisation de la souris.

== Gestion des fichiers S1P (format Touchstone)

La classe `TouchstoneS1P` est un parser développé pour cette application qui est capable de lire et d'exporter les fichiers .s1p selon le standard Touchstone. Ces fichiers commencent par une ligne d'options (précédée de \#) qui spécifie :
- L'unité de fréquence (Hz, kHz, MHz, GHz)
- Le type de paramètre (S, Y, Z, H, G - par défaut S pour les paramètres de scattering)
- Le format des données (DB pour dB/angle, MA pour magnitude/angle, RI pour réel/imaginaire - par défaut MA)
- La résistance de référence (R suivi de la valeur, par défaut 50$Omega$)

La méthode statique `parse(file)` lit le fichier ligne par ligne. Elle commence par parser les options via `parseOptionLine()`, puis convertit chaque ligne de données en un `DataPoint`. Elle gère les différents formats de données (DB, MA, RI) via la méthode `calculateComplexValue()`, convertit ensuite les paramètres S en impédance grâce à `calculateImpedance()`, et finalement calcule le vrai gamma avec `calculateGammaFromZ()`.

Cette classe permet aussi d'exporter les SWEEPS de fréquence du circuit créer sur l'application en fichier S1P. Les points du sweep sont alors exportés selon de format S MA R (qui sont les paramètres par défaut de ces fichiers).

=== Optimisation et Downsampling

Les fichiers S1P peuvent contenir énormément de points. Afficher tout ça ralentit l'interface. Pour éviter ce problème, un mécanisme de downsampling a été mis en place dans `S1PPlotterWindow`. Si le fichier dépasse 1500 points (`MAX_RENDER_POINTS`), l'algorithme sous-échantillonne les données pour garder environ 1500 points. On fait aussi attention à ce que le premier et dernier point du sweep soient présents.

=== Filtrage des fichiers S1P

Le logiciel permet de simplement mettre en évidence des parties du fichier S1P importé sur l'interface. Après des discussions sur l'utilité de ces mises en évidence, le système a été mis en place de façon à avoir trois plages de mises en évidence au maximum. Essayer de créer un circuit d'adaptation qui permet de satisfaire trois plages est déjà très complexe, donc il était inutile d'en choisir plus.

Ces plages de fréquences sont définies par l'utilisateur via des contrôles de type `RangeSlider` dans l'interface. Chaque filtre peut être activé ou désactivé indépendamment via des propriétés booléennes (`filter1Enabled`, `filter2Enabled`, `filter3Enabled`) stockées dans le ViewModel. Pour chaque filtre actif, on définit une fréquence minimale et maximale (`freqRangeMinF1`/`freqRangeMaxF1`, etc.).

Lors du dessin de l'abaque, le `SmithChartRenderer` parcourt tous les points S1P transformés et appelle la méthode `whichFrequencyRange(frequency)` du ViewModel pour déterminer dans quelle plage se trouve chaque point. Cette méthode retourne 1, 2 ou 3 si le point appartient à l'un des trois filtres actifs, ou -1 si aucun filtre ne correspond.

Selon le résultat, le point est dessiné avec une couleur et un style différent, si le point ne se trouve dans aucune de ces plages, il est alors mis en retrait avec une opacité moindre pour éviter d'avoir trop de points sur l'abaque, l'utilisateur peut se focaliser sur les fréquences sur lesquelles il travaille.

== Gestion des "undo/redo"

Comme tout bon programme informatique, il est très utile de revenir sur ce qu'on a pu faire. Pour cela, deux systèmes ont été mis en place.

Un système générique `HistoryManager` qui permet d'avoir une gestion de deux piles génériques. Une pile de redo et une pile de undo. Lorsqu'on consomme une action undo, l'état actuel est sauvegardé dans la pile de redo, puis l'état précédent est restauré depuis la pile d'undo. Inversement, lorsqu'on fait un redo, l'état actuel est remis dans la pile d'undo et l'état suivant est récupéré depuis la pile de redo.

Ensuite pour pouvoir utiliser ce gestionnaire, un record `UndoRedoEntry` a été mis en place, qui garde comme information l'opération effectuée (ADD, REMOVE, MODIFY), l'index du circuit modifié ainsi qu'une paire d'éléments qui lie l'élément du circuit subissant l'opération et son index dans le circuit choisi. Ensuite, selon ce que l'utilisateur fait, chaque action est gardée dans le manager et l'utilisateur peut a choix revenir sur ce qu'il a fait! Le viewModel lui s'occupe de reconstruire le circuit à chaque undo/redo.

== Les composants discrets

Dans le monde réel, les composants ne peuvent pas prendre n'importe quelle valeur. Ils existent en séries normalisées (séries E12, E24, E96, etc.) et il est pratique de pouvoir visualiser directement les valeurs des composants qu'on a sous la main, plutôt que des valeurs théoriques idéales.

L'utilisateur peut créer sa propre bibliothèque de composants disponibles via une fenêtre de dialogue (`DiscreteComponentConfigDialog`). Cette fenêtre permet d'ajouter des composants avec leur valeur exacte et leurs caractéristiques parasites, soit en utilisant le facteur de qualité, soit sous forme d'ESR. Dépendamment du constructeur du composant et de son type, les datasheets mettent à disposition soit l'un, soit l'autre (ou les deux).

Une nouvelle classe `ComponentEntry` a été mise en place pour encapsuler ces informations et pour pouvoir facilement les utiliser et aussi les exporter. L'utilisateur peut alors exporter ou importer des fichiers CSV contenant les informations nécessaires à cette bibliothèque de composants.

Ensuite, lorsque le mode "composants discrets" est activé par l'utilisateur, le comportement de l'ajout à la souris change. L'utilisateur peut toujours bouger sa souris comme il le souhaite, mais la valeur du composant calculé et son affichage se bloquent sur les valeurs des composants discrets en utilisant la méthode `getClosestComponentEntry()`. Cette méthode parcourt tous les composants du type sélectionné et trouve celui dont la valeur est la plus proche de la valeur calculée à la position actuelle de la souris. De plus, l'affichage de l'abaque rajoute des points directement sur l'abaque pour que l'utilisateur puisse voir où sont positionnés ces composants discrets.

== Le management du projet

Pour pouvoir sauvegarder l'état du projet sur lequel on travaille, il fallait mettre en place un moyen de sérialiser les informations et de les exporter dans un fichier. Le choix a été fait de ne pas garder en mémoire les fichiers S1P importés lors de la sauvegarde, ni les sweeps effectués, ni la configuration des composants discrets. Chacun peut être exporté de son côté.

Les éléments sauvegardés, stockés dans un record agissant comme DTO (Data Transfer Object), sont le nom du projet, la fréquence de travail, l'impédance caractéristique du système ($Z_0$), l'impédance de charge, et surtout tous les circuits créés par l'utilisateur (stockés sous forme de liste de listes de `CircuitElement`).

La classe `ProjectManager` s'occupe de la sérialisation et désérialisation des projets. Elle utilise la bibliothèque Jackson pour convertir les données en format JSON avec le module `Jdk8Module` pour gérer correctement les types Java modernes (comme `Optional`).

Lors de la sauvegarde du projet via la méthode `saveProject()`, le logiciel vérifie si le projet est déjà associé à un fichier. Sinon, un dialogue de sélection demande à l'utilisateur de choisir un emplacement où stocker le fichier (avec l'extension `.jsmfx`). Ensuite, le chemin du fichier est sauvegardé dans la classe et toutes les sauvegardes ultérieures se feront automatiquement sur ce même fichier. Une option "Save As" existe aussi pour pouvoir sauvegarder dans un nouveau fichier, même si le projet est déjà lié à un fichier existant.

Lors du chargement via `loadProject()`, le fichier JSON est désérialisé et toutes les propriétés du ViewModel sont restaurées. Une fois le chargement terminé, les flags `hasBeenSaved` et `isModified` sont mis à jour pour refléter l'état du projet. Ces flags sont mis à jour à chaque interaction que l'utilisateur a avec l'abaque pour indiquer si le projet a eu des changements depuis la dernière sauvegarde.

Finalement, si des changements ont eu lieu, mais qu'aucune sauvegarde n'a été effectuée lorsque l'utilisateur souhaite quitter l'application, on demande à l'utilisateur s'il est sûr de vouloir quitter. Un comportement classique de ce genre d'application.