= Outils utilisés <tools>

Lors de la conception de ce travail de Bachelor, différents outils sont utilisés pour la rédaction du rapport et la conception du code.

== Programmation

L'IDE utilisé est IntelliJ. L'application étant développée en Java, IntelliJ de JetBrains est l'environnement que je maîtrise le mieux, ce choix était donc logique. Les technologies principales s'articulent autour de JavaFX version 25, qui nécessite JDK 23, pour la gestion de l'interface graphique. C'est le squelette du projet, l'ensemble de l'application repose sur cette bibliothèque, que ce soit pour le dessin de l'abaque ou pour la logique de l'interface utilisateur. 

Un outil intéressant, supporté nativement dans IntelliJ, est JavaFX Scene Builder. À la manière de QtCreator, il permet de s'aider d'une interface visuelle pour créer les vues de l'application.

AtlantaFX#footnote("Repos GitHub de la bibliothèque : https://github.com/mkpaz/atlantafx") est une bibliothèque qui permet d'ajouter un thème moderne à l'application JavaFX. Cela évite de devoir créer des composants customs pour les éléments simples et me permet de me focaliser sur l'écriture du code.

Ensuite, pour compiler l'application, j'utilise Gradle. C'est un concurrent à Maven qui est, d'après mon expérience, plus performant et plus stable.

== Conception

Le diagramme UML, réalisé en parallèle de l'écriture du code, est conçu avec l'outil PlantUML. Ce choix permet une approche programmatique de la modélisation, facilitant la mise à jour du diagramme au fur et à mesure de l'avancement du développement.

== Versionning

Le projet étant individuel, un simple dépôt Git a été mis en place sur GitHub pour jalonner chaque étape. J'ai décidé de ne pas complexifier le processus avec la gestion d'issues pour le moment.

Le projet est organisé en deux dépôts, un pour l'application (le code source), et un second pour la partie académique (le rapport de TB).

== Rapport

L'entièreté du rapport est rédigée sur Typst, à l'aide de l'extension Tinymist Typst#footnote("Lien de l'extension sur VSC : https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist") sur Visual Studio Code. Ensuite, pour la correction d'éventuelles fautes d'orthographe, le logiciel Antidote#footnote("Lien d'Antidote : https://www.antidote.info/fr/") a été utilisé.

== Utilisation de LLMs

Différents LLMs (Gemini et GPT majoritairement) ont été utilisés pour aider à la reformulation de certaines parties du rapport. L'outil GitHub Copilot a également été utilisé comme aide à la conception du code.