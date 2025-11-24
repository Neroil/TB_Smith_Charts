= Principes théoriques <principes-theoriques>

Pour pouvoir développer une solution d'abaque de Smith digitale, il faut tout d'abord comprendre comment celle-ci fonctionne et comment on l'utilise. Ce chapitre a pour but de poser les bases théoriques nécessaires à la compréhension de l'outil.

== Pourquoi l'abaque de Smith ?

L'abaque de Smith existe dans le contexte de l'utilisation et la transmission des fréquences radio (RF). Dans ce domaine, on a souvent affaire à des circuits qui opèrent à hautes fréquences et dont le comportement est décrit par une grandeur complexe, l'impédance.

L'impédance $Z$ est une grandeur complexe qui allie une partie réelle, la resistance $R$ totale d'un circuit, avec une partie imaginaire qui s'appelle la réactance $X$.

#align(center, $Z = R + j X$)

Ensuite cette réactance peut soit être capacitive $X_C$ (comme un condensateur) ou bien elle peut être inductive $X_L$ (comme une bobine). La valeur de la résistance est généralement considérée comme constante par rapport à la fréquence, tandis que la réactance en dépend fortement, la réactance inductive augmente avec la fréquence, alors que la réactance capacitive diminue. 

#align(center, $X_C = -frac(1,2 pi f C) wide X_L = 2 pi f L$)

En radiofréquence, l'objectif est de transférer un signal le plus efficacement possible entre une source émettrice et une charge (une antenne, par exemple). Pour ce faire, il faut assurer que le transfert de puissance soit maximal. Si l'on envoie 100W de puissance RF, on veut que notre antenne rayonne l'entièreté de ces 100W.

Si ce n'est pas le cas, on parle de désadaptation d'impédance. L'énergie qui n'est pas transmise à la charge est alors réfléchie vers la source, ce qui induit deux problèmes majeurs: une perte d'efficacité, car une partie de la puissance transmise n'est tout simplement pas rayonnée et un danger pour la source qui peut être endommagée par cette réflexion.

Pour obtenir ce transfert de puissance maximal, l'impédance de la charge doit être le conjugué complexe de l'impédance de la source. Malheureusement, ce cas idéal n'arrive que très rarement en pratique. Il faut alors insérer un circuit d'adaptation entre la source et la charge. Le rôle de ce circuit est de transformer l'impédance de la charge pour qu'elle soit adaptée à sa source.

TODO : FAIRE UN SCHéMA EXPLIQUANT LE CONJUGUE COMPLEXE

=== Quantifier la réflexion

Cette désadaptation est quantifiable mathématiquement avec le coefficient de réflexion gamma ($Gamma$). Ce coefficient est calculé avec cette formule-ci : 

#align(center, $Gamma = frac(Z_L - Z_0,Z_L + Z_0)$)

Ou $Z_L$ est l'impédance de la charge et $Z_0$ est l'impédance de la ligne de transmission (50 Ohm dans les cas les plus courants). Avec cette formule, on peut voir que, si l'impédance de la source et de la charge sont les mêmes, on obtient alors 0, une adaptation parfaite. Alors qu'inversement, plus la différence entre $Z_0$ et $Z_L$ est grande, plus le module du coefficient se rapprochera du 1, une réflexion alors totale de l'énergie.

Physiquement, les conséquences de cette réflexion sont l'apparition d'onde stationnaire. Ces ondes sont des pics de courant qui arrive lorsqu'un milieu câblé reçoit un courant de retour en plus d'un courant d'allée. Ce qu'il se passe c'est que les deux fréquences vont se superposer et former des ondes stationnaires. 

#figure(image("../template/images/01-Standing-Wave-t0-1024x448.jpg", width:80%), caption: [Phénomène des ondes stationnaires #footnote[Source #link("https://sciencesanctuary.com/standing-waves")[Science Sanctuary]]])

Ce sont ces ondes stationnaires qui sont les causes physiques de problèmes mentionnés plus haut. Et à partir de ces ondes stationnaires, on peut calculer le VSWR (Voltage Standing Wave Ratio) qui est une mesure du rapport entre l'amplitude maximale et l'amplitude minimale que peut atteindre l'onde stationnaire.

#align(center, $"VSWR" = frac(1 + |Gamma| , 1 - |Gamma|)$)

Finalement, à partir de cette mesure, on peut aussi calculer le montant de puissance du signal qui est retourné à la source, une mesure appelée Return Loss, qui est exprimée en décibel.

#align(center, $"Return Loss" = 20 log_10 (frac("VSWR" + 1 , "VSWR" - 1))$)



=== Représentation graphique

Sans entrer dans des détails pas très importants pour le projet, les calculs pour trouver les bons composants étaient longs et fastidieux, et on a vite commencé à utiliser des représentations graphiques pour trouver ces composants. 

La représentation graphique est une représentation du point d'impédance de la charge $Z_L$ par rapport à l'impédance de référence de la ligne $Z_O$. On pose alors sur l'axe des ordonnées la relation imaginaire, la réactance $X$. Et sur l'axe des abscisses, la relation réelle, la résistance.

 Il est complexe de représenter cette relation sur le plan cartésien, car on utilise d'une part seulement le côté droit du plan, étant donné que la résistance ne peut être négative, mais surtout qu'autant les valeurs de réactance comme de résistance peuvent pointer vers l'infini, rendant impossible la visualisation de toutes les impédances sur une seule feuille.

C'est là que l'abaque de Smith offre la solution. Au lieu de représenter directement le plan des impédances, l'abaque de Smith est une représentation graphique du plan du coefficient de réflexion complexe $Gamma$.

Comme le module de $Gamma$ est toujours compris entre 0 et 1, toutes les valeurs possibles peuvent être contenues à l'intérieur d'un cercle de rayon 1. Smith a ensuite développé une transformation mathématique qui permet de superposer des lignes de résistance et de réactance constantes sur ce même plan circulaire. On obtient ainsi un diagramme où chaque point correspond à la fois à une valeur d'impédance unique et son coefficient de réflexion associé.

#figure(image("../template/images/Smith_chart_explanation.svg.png", width:80%), caption: [Explication graphique de l'abaque #footnote[Source Sbyrnes321 sur #link("https://en.wikipedia.org/wiki/Smith_chart#/media/File:Smith_chart_explanation.svg")[Wikipedia]]])

=== Lire l'abaque

Tout comme sur le schéma sur un plan cartésien, l'axe des ordonnées est l'axe des nombres imaginaire et l'axe des abscisses est l'axe des nombres réel, la résistance. Du côté gauche complètement réel de l'abaque, on a une résistance nulle, un court circuit. Et du côté droit complètement réel, on a une résistance "infinie", en gros un circuit ouvert. À partir de là, on peut voir que l'abaque est dessiné avec deux types de lignes. D'abord, il y a des cercles qui se touchent tous au point de circuit ouvert. Ce sont les cercles de résistance constante. Chaque point se trouvant sur un même cercle partage exactement la même partie résistive.

 TODO SCHéMA des cercles de résistance

Ensuite, des courbes partent toutes du même point de circuit ouvert et s'étendent vers l'extérieur. Ces courbes représentent les lignes de réactance constante. La moitié supérieure de l'abaque correspond aux réactances inductives ($+j X$), tandis que la moitié inférieure représente les réactances capacitives ($-j X$). Tout comme pour les cercles, chaque point situé sur la même courbe possède la même partie réactive.

TODO SCHéMA sur les courbes de réactance

Jusqu'ici, on a parlé de l'abaque d'impédance, aussi appelé la forme Z de l'abaque. Il est parfait pour visualiser l'ajout de composants en série, car les impédances s'additionnent. Mais pour pouvoir pleinement utiliser l'outil dans le cas de la recherche de circuits d'adaptation, il nous faut aussi pouvoir gérer les composants en parallèle (shunt).

Pour cela, on utilise aussi un abaque d'admittance ($Y$) qui est simplement l'inverse de l'impédance ($Y = 1/Z$). La partie réelle de l'admittance est appelée la conductance et la partie imaginaire la susceptance. 

Graphiquement, cet abaque est exactement la même que l'abaque des impédances, mais pivotée de 180 degrés, on peut alors superposer les deux abaques dans un mode commun qui est aussi appelé abaque $Z-Y$. C'est cette visualisation de l'abaque qui est le plus pratique et qui est utilisée majoritairement par les logiciels actuels. Cela sera aussi cet abaque que nous allons dessiner dans notre version du logiciel.

=== Utiliser l'abaque

Maintenant, pour l'utiliser, rien de plus simple, on mesure l'impédance de notre composant de charge. On positionne cette mesure sur l'abaque. Dans le cas d'un abaque papier, cette mesure devra être normalisée par rapport à l'impédance de référence. Par exemple, si notre impédance mesurée est de 75 + j50 Ohms dans un système à 50 Ohms, cette impédance se trouvera sur un point normalisé de 1.5 + j1 sur l'abaque.

#align(center, grid(
    columns:2,
    figure(image("../template/images/smithexe/point_base.png", width:100%), caption: [Impédance de 75 + j50 Ohm]),
    figure(image("../template/images/smithexe/point_adapte.png", width:100%), caption: [Impédance avec circuit d'adaptation#footnote("Schémas provenant du logiciel Smith.exe")])
))

Ensuite, le but du jeu est de ramener ce point le plus proche du centre de l'abaque possible, le point d'adaptation parfaite. Et pour y arriver, on va ajouter des composants, des inductances et des condensateurs, soit en série, soit en parallèle. Ce n'est pas le seul moyen de pouvoir adapter la charge, mais c'est le moyen sur lequel ces explications vont se reposer.

#figure(image("../template/images/incidance_composants_smith.png", width:50%), caption: [Effet d'ajouts d'inductances et de capacités en série et parallèle#footnote[Cours sur l'abaque de Smith de l'IUFM d'Aix Marseille par Denis Rabasté]])

Selon le composant qu'on ajoute et selon son placement dans le circuit, l'impédance vue depuis la source va changer de position sur l'abaque. En se basant sur l'exemple de notre impédance mesurée, une des possibilités est d'utiliser le circuit ci-dessous pour réaliser l'adaptation:

#align(grid(
    columns:(1fr,0.3fr,2fr),
    image("image.png",width: 100%),
    "",
    text()[
    1. Ajout d'un condensateur en série de 1.9pF pour rejoindre le cercle de conductance qui à l'échelle de 50 Ohms indique une conductance de 4 millisiemens constante.
    2. Ajout d'un condensateur en parallèle de 621.8 fF pour ensuite rejoindre le cercle de résistance constante de 50 Ohms, c'est grâce à celui-ci que nous allons pouvoir nous rapprocher du centre.
    3. Finalement, l'ajout d'une inductance en série de 31.6 nH pour nous ramener vers le centre de l'abaque en suivant le cercle de résistance constante de 50 Ohms.
    ]
))

C'est en cela que l'abaque de Smith est extrêmement puissants.


