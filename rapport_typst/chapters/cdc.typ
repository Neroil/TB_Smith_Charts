= Cahier des charges <cahier-des-charges>
== Résumé du problème <résumé-du-problème>

L'abaque de Smith est un outil très important dans le domaine de la conception et de l'analyse d'antennes. Il permet de visualiser et de manipuler les impédances complexes en les projetant sur le plan du coefficient de réflexion.

Dans un monde parfait, une antenne devrait transférer toute sa puissance vers le milieu de propagation, l'air par exemple, sans aucune perte. Cependant, en réalité, l'impédance des antennes est très rarement adaptée adaptée à celle de la ligne de transmission qui leur fournit le signal. Cette différence d'impédance crée des ondes stationnaires et un phénomène de réflexion.
Cette réflexion, en plus d'être potentiellement dangereuse pour la source de courant (puisqu'une partie de la puissance émise est renvoyée vers celle-ci), diminue également l'efficacité de l'antenne.

Pour pallier ce problème, on peut adapter une impédance à une autre en ajoutant, en série ou en parallèle (shunt), des condensateurs ou des inductances. C'est là que l'abaque de Smith entre en jeu, il aide l'utilisateur à choisir les bons composants afin de réduire le coefficient de réflexion et d'obtenir une adaptation optimale.

Actuellement, les étudiants en systèmes embarqués utilisent un logiciel développé par Fritz Dellsperger, un professeur de la Haute école spécialisée bernoise (BFH) aujourd'hui à la retraite, pour leurs laboratoires sur les antennes. Ce logiciel, exclusif à Windows et appelé *Smith V4.1*, n'est que très peu mis à jour (dernière version en 2018) et présente plusieurs problèmes d'affichage et de dimensionnement, rendant son interface peu ergonomique et difficile à utiliser.


=== Problématique <problématique>
Comment fournir aux étudiants un logiciel intuitif, simple d'utilisation et agréable à prendre en main pour manipuler digitalement une abaque de Smith ?

=== Solutions existantes <solutions-existantes> TODO TESTER LES SOLUTIONS
Il existe bien entendu d'autres logiciels, natifs ou en ligne, qui permettent de manipuler un abaque de Smith. 

Par exemple, *SimSmith* (appelé SimNec dans ses versions récentes)#footnote[https://www.ae6ty.com/smith_charts/] est un outil multiplateforme développé en Java. L'outil semble très complet, quoique pas très intuitif au premier abord.

*linSmith*#footnote[https://jcoppens.com/soft/linsmith/index.en.php] est aussi une bonne alternative, avec une interface utilisateur agréable. Son gros point faible est qu'il ne tourne que sous Linux.

Il existait également *Iowa Hills Smith Chart*, mais le développement semble être tombé en désuétude et il n'y a apparemment plus de moyen de télécharger l'application actuellement.


Finalement, il existe des solutions purement en ligne telles que https://quicksmith.online/ et https://onlinesmithchart.com/, qui restent à évaluer dans le cadre de ce travail.

=== Solutions possibles <solutions-possibles>
On peut alors soit utiliser les solutions énumérée plus haut ou bien faire notre propre application qui répond exactement aux besoin des étudiants et professeurs de l'HEIG. 

== Cahier des charges <cahier-des-charges-1>


=== Objectifs <objectifs>

Les objectifs principaux du projet sont : 

- Fournir un logiciel multiplateforme (volontée de ne pas forcer l'utilisateur à un système d'exploitation).
- Avoir un logiciel avec une interface moderne, intuitive, adaptée à l'enseignement à l'HEIG (pas besoin d'être exhaustif dans les fonctionnalité, seulement ce qu'on a besoin).
- fonctionnalités similaire à Smith.exe.
- Avoir un logiciel évolutif dans le code.

=== Spécifications fonctionnelles

Fonctionnalités minimales :
- Affichage d'une abaque de Smith interactive.
- Placement d'impédances et/ou d'admittances.
- Placement de composants passifs en série ou en parallèle (R, L, C, ligne, stub).
- Chargement de fichiers S1p.
- Fonction Sweep et tuning.

Fonctionnalités avancées :
- Édition de plusieurs circuits simultanément (jusqu'à 10) à partir d'une même paire [charge, source].
- Choix de couleur pour la trajectoire de chaque circuit.
- Fenêtre “Cursor” : curseur aimanté sur les points calculés.
- Zoom et pan paramétrables.
- Export de fichiers S1p issus d'un sweep.
- Tuning basé sur des valeurs normalisées CEI 60063.
- (Optionnel) Affichage Z, Y, Mod/Arg pour les points intermédiaires.

=== Déroulement <déroulement>
Le travail commence le 3 novembre 2025 et se termine le 16 janvier 2026. L'entièreté de ce travail sera réalisé à plein temps.

Un rendu intermédiaire noté est demandé le 25 novembre 2025 à 15 heures et le rendu final est prévu pour le x à 12h00.

La défense sera organisée entre le x et le y.

=== Livrables <livrables>
Les délivrables seront les suivants :

- A voir avec le prof de TB 