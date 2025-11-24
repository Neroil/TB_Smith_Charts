= État de l'application au rapport intermédiaire <implementation>

Pour le moment, l'application n'est bien entendue pas terminée, mais après avoir mis en place les différentes bibliothèques et le language utilisé, j'ai pu développer un début d'application qui contient les éléments de base du fonctionnement d'un abaque de Smith. 

#figure(image("../images/JSmithFX_overview.png",width:100%), caption : "Overview de l'application")

Pour le moment l'application ne propose qu'un mode sombre mais bien entendu il y aura le choix entre un mode clair et un mode sombre dans l'application finale.

Ce qui a été déjà mis en place : 

- Ajout de composants RLC en série et en parallèle.
- Ajout de ligne et de stub ouvert et fermé.
- Visualisation de l'abaque de Smith.
- Visualisation du circuit créé par l'ajout de composant sur l'abaque.
- Calcul des valeurs nécessaires à l'utilisation de l'abaque. 
- Ajout des composants soit en entrant les valeurs directement ou bien en utilisant la souris (qui se magnétise ou elle doit se trouver).

On obtient alors un logiciel utilisable même s'il manque des grosses fonctionnalités qui sont nécessaires tel que le Sweep ou le Tuning.

== Déploiement

Pour déployer l'application de façon multiplateforme, deux choix s'offre à nous, soit on construit une image `.jar` (un uberJar plus précisément en utilisant l'outil gradle shadowJar) qui permet de lancer l'application n'importe ou la JVM est installée. Soit on construit build une application propre à chaque plateforme pour ensuite que l'utilisateur télécharge la version appropriée du programme. Le point fort de la seconde manière est qu'on n'a pas besoin d'obliger l'utilisateur d'avoir Java d'installé sur son appareil, mais le problème est qu'on perd la portabilité d'un `.jar`.

Le choix alors se porte sur un déploiement utilisant les outils de CI/CD pour à la fois proposer la version portable en `.jar`, en indiquant à l'utilisateur qu'il doit avoir java sur sa machine, et à la fois builder l'application pour windows, linux et macOs. 


