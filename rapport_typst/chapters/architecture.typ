= Architecture

L'application est un logiciel qui doit afficher des éléments graphiques complexes (l'abaque) et permettre à l'utilisateur de visualiser des données pour effectuer l'adaptation d'impédance.

Comme annoncé dans l'état de l'art, la bibliothèque JavaFX permet de concevoir ce type d'application en utilisant le pattern "MVVM" (Model-View-ViewModel).

#figure(image("../images/schemaUMLSimple.png", width:100%),
caption: [Schéma simplifié de l'architecture du projet])

== Partie Vue

La vue de l'application est, comme son nom l'indique, ce que l'utilisateur peut voir. C'est la partie émergée de l'iceberg. Dans une application JavaFX, elle se manifeste principalement par un fichier *.fxml*. C'est ce fichier qui est édité via l'outil Scene Builder pour modifier graphiquement l'interface utilisateur.

Ce fichier fxml est complété par une bibliothèque d'éléments d'interface utilisateur moderne AtlantaFX et d'une feuille CSS pour davantage personnaliser l'interface.

En plus de ce fichier qui gère les éléments simples, il a fallu mettre en place plusieurs classes spécifiques pour chaque élément, visibles sur le diagramme :

- `SmithChartRenderer` : Cette classe s'occupe de dessiner l'abaque de Smith sur un objet `Canvas` JavaFX. Elle redessine la grille, les cercles VSWR et les tracés d'impédance à chaque changement de données.

- `SmithChartLayout` : Une classe utilitaire qui gère les conversions entre coordonnées du coefficient de réflexion gamma (plan complexe) et coordonnées pixel à l'écran. Elle centralise les calculs de positionnement sur le `Canvas`.

- `CircuitRenderer` : Cette classe dessine le schéma électrique du circuit en fonction des composants ajoutés (résistances, lignes, etc.).

- `S1PPlotterWindow` : Une fenêtre dédiée pour afficher les données d'un fichier S1P sous forme de diagramme cartésien (Log Magnitude / Fréquence).

- `ChartPoint` : Une classe utilitaire qui sert à gérer la détection de la souris sur les points du graphique ("hit detection") pour afficher les infobulles (tooltips).

- `Les Dialogues personnalisés` : Plusieurs classes (comme `SweepDialog` ou `ComplexInputDialog`) ont été créées pour demander des informations complexes à l'utilisateur. Vu leur complexité, il était nécessaire de créer des classes supplémentaires pour les organiser.

Enfin, une classe utilitaire `StageController` a été ajoutée pour gérer le titre de la fenêtre principale, notamment pour indiquer visuellement à l'utilisateur si le projet contient des modifications non sauvegardées (ajout d'un astérisque \* dans le titre).

=== Ajouts et modification d'éléments dans le circuit

Pour offrir à l'utilisateur une flexibilité totale sur l'ajout d'élément dans le circuit, la partie schématique du circuit permet à l'utilisateur de choisir où il rajoute son composant. Ce qui n'est pas possible sur le logiciel Smith.exe par exemple.

Cette fonctionnalité est gérée par le `CircuitRenderer` qui affiche des petits boutons d'ajout entre chaque composant du schéma électrique. Lorsque l'utilisateur clique sur l'un de ces boutons, il sélectionne le point d'insertion. Ensuite, le prochain composant ajouté sera mis juste après ce point. La prévisualisation se fait de façon logique selon l'endroit ou le composant est inséré.

En plus de la fonction d'insertion, il est possible de cliquer sur chaque élément du schéma électrique du circuit pour pouvoir effectuer le fine-tuning et de complètement modifier le composant sélectionné. Le circuit est alors complètement modifiable. 

=== MainController

La logique de l'interface est gérée par les contrôleurs. JavaFX fournit une possibilité de faire le lien entre les différents boutons et interactions avec le contrôleur principal de l'application, le `MainController`, qui fait le lien entre les boutons de l'interface et les fonctions du programme grâce à l'annotation `@FXML`. C'est cette classe que JavaFX consulte pour effectuer les actions lorsqu'on appuie sur des boutons.

Le `MainController` s'occupe principalement de :

- *Gestion des menus et actions utilisateur* : Importer/exporter des fichiers S1P, créer/sauvegarder des projets, gérer les circuits multiples, etc.

- *Binding avec le ViewModel* : Synchroniser les champs de texte (fréquence, impédance) avec les propriétés observables du ViewModel, mettre à jour les tables de données, etc.

- *Orchestration des dialogues* : Ouvrir les fenêtres de configuration (sweep, ajout de composants, édition de valeurs) et traiter leurs résultats.

- *Gestion de l'état de l'interface* : Afficher/masquer des sections selon le contexte (panneau S1P lorsqu'un fichier est chargé, panneau de sweep lors d'une simulation, etc.).

- *Coordination avec CircuitRenderer* : Redessiner le schéma électrique à chaque modification du circuit.

Cependant, vu la richesse des interactions possibles sur l'abaque (zoom, pan, ajout à la souris), le `MainController` devenait trop chargé. Une classe `SmithChartInteractionController` a donc été introduite pour déléguer toute la logique spécifique aux interactions avec le graphique de l'abaque de Smith. Le `MainController` reste ainsi focalisé sur l'orchestration globale de la fenêtre et des menus.

== Partie Modèle

Le modèle est le squelette des données de l'application, c'est la logique métier de l'application. Il contient les différents composants (`CircuitElement`), les unités, et la gestion des nombres complexes. C'est ici qu'on définit comment se comportent les éléments dans le plan physique.

=== Données et éléments du circuit

Le but de l'abaque de Smith est d'élaborer un circuit d'adaptation. Modéliser les différents composants est donc très important. Le logiciel permet d'ajouter quatre types de composants différents :

*Les composants classiques (Résistance, Condensateur et Inducteur)* : Ces composants se comportent de façon similaire, on peut facilement calculer leur impédance complexe à partir de la fréquence du circuit que l'on construit. Ensuite on choisit si on ajoute cette impédance en série (une simple addition) ou bien en parallèle (et on utilise la fonction de `SmithCalculator` appelée `addParallelImpedance`).

En plus de ça, un facteur de qualité (Q) a été mis en place pour les condensateurs et les inducteurs qui permet d'avoir des simulations de circuit d'adaptation plus réalistes.

*Les lignes de transmission* : Ces lignes se comportent très différemment des autres composants. Leur effet change drastiquement selon l'impédance d'entrée de la ligne, c'est pour cela que la manière de calculer l'impédance ne peut pas se faire de façon isolée. La classe `Line` implémente donc une méthode `calculateImpedance(currentImpedance, frequency)` qui prend en compte l'impédance actuelle du circuit, c'est-à-dire l'impédance au départ de la ligne.

Tous ces composants héritent de la classe abstraite `CircuitElement` qui définit les propriétés communes, tels que la valeur réelle du composant, la position (série ou parallèle). Cette position permet aussi de savoir si une ligne va être un stub ou non. Le facteur de qualité est aussi mis dans cette classe abstraite.

=== Les unités

Chaque composant utilise des unités différentes. Pour faciliter la rédaction du code et pour avoir un code plus "propre", un système de gestion des unités a été mis en place. Toutes les unités implémentent une interface `ElectronicUnit` qui présente la fonction `getFactor()` permettant d'obtenir le facteur de conversion de l'unité choisie vers son unité de base (ex : les picofarads ont comme facteur 1E-12). Ensuite, différentes énumérations implémentent cette interface :

- `CapacitanceUnit` : pF, nF, μF, mF
- `InductanceUnit` : H, mH, μH, nH
- `ResistanceUnit` : Ω, kΩ, MΩ 
- `DistanceUnit` : mm, m, km 
- `FrequencyUnit` : Hz, kHz, MHz, GHz

=== Les points de données

Lorsqu'on ajoute un composant sur l'abaque, on affiche aussi ses informations dans une partie de l'interface nommées "DataPoint". Ce format de donnée permet d'avoir accès directement aux informations de chaque point du circuit. La classe `DataPoint` encapsule toutes les informations nécessaires, telles que la fréquence du point, son nom (le label affiché), son impédance complexe, son coefficient de réflexion, le VSWR (Voltage Standing Wave Ratio), la perte de retour (Return Loss) en dB et finalement le facteur de qualité de chaque point.

Ces datapoints sont aussi utilisés pour stocker les informations qui ne font pas partie du circuit, comme par exemple, les informations liées aux sweeps ou bien aux fichiers S1P.

== Partie ViewModel

Le ViewModel est la partie qui contient l'état de l'application, c'est la mémoire, mais aussi le cerveau. C'est lui qui s'occupe de mettre à jour les valeurs et de recalculer la chaîne d'impédance lorsqu'on modifie le circuit. La classe `SmithChartViewModel` agit comme l'unique source de vérité pour l'état de l'application et quasiment toutes les autres classes dépendent d'elle pour le comportement de l'abaque.

=== Les JavaFX Properties

JavaFX met à disposition des classes spéciales, les *JavaFX Properties*. Elles sont intrinsèquement observables, ce qui veut dire qu'on peut réagir dès qu'elles sont modifiées. Les différentes classes mettent en place des "listeners" qui déclenchent une interaction dès qu'une valeur change. Ou bien on peut aussi mettre en place des méthodes qui lient des éléments d'interfaces à des valeurs dans le viewModel.

Le ViewModel est constitué de plusieurs catégories de propriétés :

*Les propriétés physiques du système* : Ce sont les paramètres "principaux" de l'abaque de Smith. On trouve l'impédance caractéristique du système (`zo`, généralement 50Ω), l'impédance de charge au départ de la chaîne (`loadImpedance`) et la fréquence du système (`frequency`). Chacune de ces propriétés est observée, et toute modification déclenche automatiquement un recalcul complet de la chaîne d'impédance.

*Les collections de données* : Le ViewModel gère plusieurs listes observables (`ObservableList`) qui stockent les différents types de points affichés sur l'abaque. Les `dataPoints` contiennent les points du circuit principal (l'impédance cumulée à chaque étape). Les `s1pDataPoints` stockent les données importées depuis un fichier S1P, et les `transformedS1PPoints` représentent ces mêmes points après transformation par les composants du circuit. Les `sweepDataPoints` contiennent les résultats d'un balayage en fréquence. Finalement, une liste `combinedDataPoints` agrège tous ces points pour faciliter le rendu graphique.

*Les propriétés d'interaction utilisateur* : Pour afficher les informations en temps réel lors du survol de l'abaque avec la souris, le ViewModel maintient des propriétés comme `mouseGamma`, `mouseImpedanceZ`, `mouseAdmittanceY`, `mouseVSWR`, `mouseReturnLoss` et `mouseQualityFactor`. Ces valeurs sont calculées instantanément lorsque la souris se déplace sur l'abaque et sont affichées dans l'interface via un binding.

*Les propriétés d'état de l'application* : Le ViewModel garde également la trace de l'état global, tel que le nom du projet (`projectName`), si le projet a été sauvegardé (`hasBeenSaved`), s'il a été modifié (`isModified`), ou encore si l'utilisateur est en train de modifier un composant (`isModifyingComponent`). Un flag `isRedrawing` permet d'éviter les redessins redondants via le mécanisme de debouncing expliqué précédemment.

=== Gestion de plusieurs circuits

L'application permet de gérer plusieurs circuits pour le même système de base, c'est une fonctionnalité qui a été rajoutée sur la fin du projet. La manière dont elle a été conçue fait en sorte que le système en lui-même ne soit pas au courant qu'il travaille sur plusieurs circuits. Lorsque l'utilisateur le choisit, le ViewModel change simplement de circuit principal.

Le ViewModel gère une liste observable `allCircuits` qui contient plusieurs `ObservableList<CircuitElement>`, chaque liste représentant un circuit distinct. Une propriété `circuitElementIndex` indique quel circuit est actuellement actif. La propriété `circuitElements` est alors liée dynamiquement au circuit actif via un binding JavaFX `circuitElements.bind(Bindings.valueAt(allCircuits, circuitElementIndex))`.

Ce binding va alors changer dynamiquement la référence sur le circuit actif et, vu que le circuit change, le viewModel va lancer un calcul complet de tous les éléments. On sépare complètement la notion de plusieurs circuits du calcul et de l'affichage de l'abaque. La vue et tous les éléments liés aux calculs ne voient que le circuit actif.

=== Utilisation du pattern Singleton

Dans la logique de l'application, il ne doit y avoir qu'un seul ViewModel vu que c'est, comme dit plus tôt, l'unique source de vérité. Pour imposer cet aspect, l'utilisation d'un pattern Singleton était nécessaire. Il était aussi utile, dans certaines classes, de pouvoir simplement accéder à l'état de l'application avec un simple `SmithChartViewModel.getInstance()`, cela évite de devoir passer l'objet en référence directement.

On utilise aussi ce pattern pour la fenêtre du graphe MagLog pour les fichiers S1P.