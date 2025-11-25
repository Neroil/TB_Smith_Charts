= État de l'application au rapport intermédiaire <implementation>

Pour le moment, l'application n'est bien entendu pas terminée. Cependant, après avoir mis en place les différentes bibliothèques et le langage, j'ai pu développer une version initiale qui contient les éléments de base du fonctionnement d'un abaque de Smith.

#figure(image("../images/JSmithFX_overview.png",width:100%), caption : "Vue d'ensemble de l'application")

Actuellement, l'interface ne propose qu'un mode sombre, mais le choix entre mode clair et mode sombre sera intégré dans l'application finale.

Les fonctionnalités déjà mises en place sont :

- Ajout de composants RLC en série et en parallèle.
- Ajout de lignes de transmission et de stubs (ouverts et fermés).
- Visualisation graphique de l'abaque de Smith.
- Visualisation du schéma du circuit créé par l'ajout de composants.
- Calcul en temps réel des valeurs nécessaires à l'utilisation de l'abaque (VSWR, Return Loss, etc.).
- Ajout des composants soit en entrant les valeurs manuellement, soit en utilisant la souris (avec un système d'aimantation là où le curseur doit se trouver).

On obtient alors un logiciel utilisable, même s'il manque encore des fonctionnalités majeures nécessaires telles que le *Sweep* ou le *Tuning*.

== Déploiement

Pour déployer l'application de façon multiplateforme, deux choix s'offrent à nous. Soit on construit une image `.jar` (un *UberJar* plus précisément, en utilisant l'outil Gradle ShadowJar) qui permet de lancer l'application n'importe où, là où la JVM est installée. Soit on génère une application propre à chaque plateforme que l'utilisateur télécharge selon son système.

Le point fort de la seconde méthode est qu'on n'oblige pas l'utilisateur à avoir Java installé sur son appareil, mais on perd la portabilité du `.jar`.

Mon choix se porte alors sur un déploiement utilisant les outils de CI/CD pour proposer les deux solutions, la version portable en `.jar` (en indiquant le prérequis Java), et des exécutables natifs pour Windows, Linux et macOS.