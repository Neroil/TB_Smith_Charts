= Outils utilisés <tools>

Lors de la conception de ce travail de Bachelor, différents outils sont utilisés pour la rédaction du rapport et la conception du code.

== Programmation

L'IDE utilisé est IntelliJ. L'application étant développée en Java, IntelliJ de JetBrains est l'environnement que je maîtrise le mieux, ce choix était donc logique. Les technologies principales s'articulent autour de JavaFX version 25 (nécessitant le JDK 23) pour la gestion de l'interface graphique. C'est le squelette du projet, l'ensemble de l'application repose sur cette bibliothèque, que ce soit pour le dessin de l'abaque ou pour la logique de l'interface utilisateur. 

Un outil intéressant, supporté nativement dans IntelliJ, est JavaFX Scene Builder. À la manière de QtCreator, il permet de s'aider d'une interface visuelle pour créer les fichiers FXML des vues de l'application.

AtlantaFX @atlantafx est une bibliothèque qui permet d'ajouter un thème moderne à l'application JavaFX. Cela évite de devoir créer des composants personnalisés pour les éléments simples et me permet de me focaliser sur l'écriture du code. En complément, la bibliothèque FXThemes#footnote("Lien de la bibliothèque : https://github.com/dukke/FXThemes") (de Pixelduke) permet de gérer le style de l'encadrement de la fenêtre sous Windows (Win10/11 Dark Mode). En parallèle, la bibliothèque jSystemThemeDetector#footnote("Lien de la bibliothèque : https://github.com/Dansoftowner/jSystemThemeDetector") de Daniel Gyoerffy est utilisée pour détecter automatiquement le thème actuel du système d'exploitation de l'utilisateur (sombre ou clair).

Pour enrichir l'interface utilisateur, la bibliothèque ControlsFX est utilisée, notamment pour les composants avancés comme les `RangeSlider` ou les `ToggleSwitch` qui ne sont pas disponibles dans JavaFX de base.

Pour la sérialisation et la désérialisation des données (sauvegarde des projets), la bibliothèque Jackson est utilisée avec son module `jackson-datatype-jdk8` pour gérer les types modernes de Java (comme `Optional`). Les tests unitaires sont réalisés avec JUnit Jupiter (version 6.0.2).

Enfin, pour la gestion des dépendances et la compilation, j'utilise Gradle. C'est un outil performant et flexible. Le projet utilise également le plugin Gradle "Shadow" pour la génération d'un "Fat Jar" (ou UberJar), une archive exécutable unique incluant toutes les dépendances nécessaires au lancement de l'application sur n'importe quelle machine équipée d'une JVM dans la bonne version.

== Conception

Le diagramme UML, réalisé en parallèle de l'écriture du code, est conçu avec l'outil PlantUML. Ce choix permet une approche programmatique de la modélisation, facilitant la mise à jour du diagramme au fur et à mesure de l'avancement du développement.

== Gestion de versions

Le projet étant individuel, un simple dépôt Git a été mis en place sur GitHub pour jalonner chaque étape. J'ai décidé de ne pas complexifier le processus avec la gestion d'issues pour le moment.

Le projet est organisé en deux dépôts, un pour l'application (le code source), et un second pour la partie académique (le rapport de TB).

== Rapport

L'entièreté du rapport est rédigée sur Typst, à l'aide de l'extension Tinymist Typst#footnote("Lien de l'extension : https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist") sur Visual Studio Code. Ensuite, pour la correction d'éventuelles fautes d'orthographe, le logiciel Antidote#footnote("Lien du site : https://www.antidote.info/fr/") a été utilisé.

Ensuite le template Typst utilisé est un projet GitHub#footnote("Lien du repos GitHub : https://github.com/DACC4/HEIG-VD-typst-template-for-TB") créé par Christophe Roulin, un étudiant de l'HEIG.

== Utilisation de LLMs

Différents LLMs (Gemini et GPT majoritairement) ont été utilisés pour aider à la reformulation et vérification de certaines parties du rapport. L'outil GitHub Copilot a également été utilisé comme aide à la conception du code, à la documentation de celui-ci (surtout la JavaDoc) et à la réalisation des tests unitaires.