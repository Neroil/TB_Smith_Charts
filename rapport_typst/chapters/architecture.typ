= Architecture <architecture>

L'application est un logiciel qui doit afficher des éléments graphiques complexes (l'abaque) et permettre à l'utilisateur de visualiser des données pour effectuer l'adaptation d'impédance.

Comme annoncé dans l'état de l'art, la bibliothèque JavaFX permet de concevoir ce type d'application en utilisant le pattern "MVVM" (Model-View-ViewModel).

#figure(image("../images/schemaUMLSimple.png", width:100%),
caption: [Schéma simplifié de l'architecture du projet])

== Partie View

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

Cette fonction complexe utilise de nombreuses fonctions de la classe `SmithCalculator` pour effectuer les calculs :

- `getArcParameters()` : Détermine le centre et le rayon du cercle ou de l'arc que le composant va suivre sur l'abaque en fonction de son type et de sa position (série ou parallèle).

- `getExpectedDirection()` : Calcule la direction dans laquelle l'arc doit être tracé (horaire ou anti-horaire) selon la nature du composant et son effet sur l'impédance.

- `calculateComponentValue()` : Convertit la position angulaire de la souris sur le cercle en une valeur de composant réelle (capacité, inductance, longueur de ligne, etc.).

Le système projette le mouvement de la souris sur le vecteur tangent au cercle, convertit ce déplacement linéaire en changement d'angle, puis recalcule la valeur du composant à chaque mouvement. Pour les lignes de transmission, le système permet une rotation infinie autour du cercle, tandis que pour les autres composants, l'angle est borné entre le point de départ et les limites physiques (circuit ouvert ou court-circuit).

Au début du projet, le mécanisme de magnétisation de la souris déplaçait directement le curseur de l'utilisateur à l'aide de la classe `Robot` de JavaFX. Cependant, lors de tests sur une machine Linux, un problème critique est apparu. Pour des raisons de sécurité de la plateforme Wayland (source : https://bugs.openjdk.org/browse/JDK-8307779), le système d'exploitation empêchait le déplacement programmatique de la souris. Cette fonctionnalité était donc inutilisable sur certaines plateformes.

Pour résoudre ce problème, il a fallu mettre en place un système de souris virtuelle basé sur deux Canvas superposés. L'un est le `smithCanvas`, le canvas principal qui contient l'abaque de Smith, les tracés d'impédance et les points de données. Ce canvas n'est redessiné que lorsque les données changent. Ensuite la nouveauté, le `cursorCanvas`, c'est un canvas transparent superposé au premier, dédié aux éléments interactifs temporaires (curseur virtuel, tooltips).

Lors de l'ajout d'un composant à la souris, un curseur virtuel est affiché sur le `cursorCanvas` à la position magnétisée correcte. L'utilisateur voit ainsi où le composant sera placé sans que la souris système ne bouge. Sur les machines Windows, la souris est tout de même déplacée mais est rendue invisible pour que le curseur personnalisé soit mis en évidence.

Le `cursorCanvas` est également utilisé pour afficher les informations lorsque l'utilisateur survole un point de l'abaque. Le système de détection (`ChartPoint`) vérifie si la souris se trouve assez près d'un point et déclenche l'affichage d'une petite fenêtre avec les informations du point (impédance, VSWR, facteur de qualité, etc.).

== Partie Model

Le modèle est le squelette des données de l'application. Il contient les différents composants (`CircuitElement`), les unités, et la gestion des nombres complexes. C'est ici qu'on définit comment se comportent les éléments dans le plan physique.

En plus des éléments des différents composants

== Partie ViewModel

Le ViewModel est la partie qui contient l'état de l'application, c'est la mémoire, mais aussi le cerveau. C'est lui qui s'occupe de mettre à jour les valeurs et de recalculer la chaîne d'impédance lorsqu'on modifie le circuit.

JavaFX met à disposition des classes spéciales, les *JavaFX Properties*. Elles sont intrinsèquement observables, ce qui veut dire qu'on peut réagir dès qu'elles sont modifiées. C'est un fonctionnement vital pour ce type d'application dynamique.

Imaginons que l'utilisateur change la fréquence ou l'impédance de charge, l'entièreté des points sur l'abaque doit bouger. Le ViewModel surveille ces valeurs et effectue un recalcul complet des informations dès qu'elles changent, mettant à jour la vue automatiquement.

À ce stade du développement, il n'y a pas encore de tests unitaires automatisés pour valider les calculs. Cependant, pour garantir la justesse des résultats, j'ai effectué une vérification manuelle systématique en comparant mes valeurs avec celles du logiciel de référence *Smith V4.1* @smith_v4. Cela m'a permis de m'assurer que le comportement de mon application est rigoureusement identique à l'existant.