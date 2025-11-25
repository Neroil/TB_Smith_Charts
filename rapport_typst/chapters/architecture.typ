= Architecture <architecture>

L'application est un logiciel qui doit afficher des éléments graphiques complexes (l'abaque) et permettre à l'utilisateur de visualiser des données pour effectuer l'adaptation d'impédance.

Comme annoncé dans l'état de l'art, la bibliothèque JavaFX permet de concevoir ce type d'application en utilisant le pattern "MVVM" (Model-View-ViewModel).

#figure(image("../images/schemaUMLSimple.png", width:100%),
caption: [Schéma simplifié de l'architecture du projet])

== Partie View

La vue de l'application est, comme son nom l'indique, ce que l'utilisateur peut voir. C'est la partie émergée de l'iceberg. Dans une application JavaFX, elle se manifeste principalement par un fichier *.fxml*. C'est ce fichier qui est édité via l'outil Scene Builder pour modifier graphiquement l'interface utilisateur.

En plus de ce fichier qui gère les éléments simples, il a fallu mettre en place deux classes spécifiques visibles sur le diagramme :
- `SmithChartRenderer` pour dessiner l'abaque de Smith.
- `CircuitRenderer` pour dessiner le circuit et ses composants.

Ensuite, grâce aux outils de JavaFX, on lie ces éléments au fichier FXML via différents *listeners* et annotations.

Enfin, JavaFX fournit une classe Controller (`SmithController`). Elle permet de faire le lien entre les boutons et les fonctions, et de gérer la logique purement graphique (comme le redimensionnement ou les clics de souris).

== Partie Model

Le modèle est le squelette des données de l'application. Il contient les différents composants (`CircuitElement`), les unités, et la gestion des nombres complexes. C'est ici qu'on définit comment se comportent les éléments dans le plan physique.

On y retrouve aussi la classe `SmithUtilities` (voir diagramme) qui contient les formules mathématiques pures, séparées de l'interface graphique.

== Partie ViewModel

Le ViewModel est la partie qui contient l'état de l'application, c'est la mémoire, mais aussi le cerveau. C'est lui qui s'occupe de mettre à jour les valeurs et de recalculer la chaîne d'impédance lorsqu'on modifie le circuit.

JavaFX met à disposition des classes spéciales, les *JavaFX Properties*. Elles sont intrinsèquement observables, ce qui veut dire qu'on peut réagir dès qu'elles sont modifiées. C'est un fonctionnement vital pour ce type d'application dynamique.

Imaginons que l'utilisateur change la fréquence ou l'impédance de charge, l'entièreté des points sur l'abaque doit bouger. Le ViewModel surveille ces valeurs et effectue un recalcul complet des informations dès qu'elles changent, mettant à jour la vue automatiquement.