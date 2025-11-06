= Principes théoriques <principes-theoriques>

Pour pouvoir développer une solution d'abaque de Smith digitale, il faut tout d'abord comprendre comment celle-ci fonctionne et comment on l'utilise. Ce chapitre a pour but de poser les bases théoriques nécessaires à la compréhension de l'outil.

== Pourquoi l'abaque de Smith ?

L'abaque de Smith existe dans le contexte de l'utilisation et la transmission des fréquences radio (RF). Dans ce domaine, on a souvent affaire à des circuits qui opèrent à hautes fréquences et dont le comportement est décrit par une grandeur complexe, l'impédance.

L'impédance $Z$ est une grandeur complexe qui allie une partie réelle, la resistance $R$ totale d'un circuit, avec une partie imaginaire qui s'appelle la réactance $X$.

#align(center, $Z = R + j X$)

Ensuite cette réactance peut soit être capacitive $X_C$ (comme un condensateur) ou bien elle peut être inductive $X_L$ (comme une bobine). La valeur de la résistance est généralement considérée comme constante par rapport à la fréquence, tandis que la réactance en dépend fortement, la réactance inductive augmente avec la fréquence, alors que la réactance capacitive diminue. 

#align(center, $X_C = -frac(1,2 pi f C) wide X_L = 2 pi f L$)

En radiofréquence, l'objectif est de transférer un signal le plus efficacement possible entre une source émettrice et une charge (une antenne, par exemple). Pour ce faire, il faut assurer que le transfert de puissance soit maximal. Si l'on envoie 100W de puissance RF, on veut que notre antenne rayonne l'entièreté de ces 100W.

Si ce n'est pas le cas, on parle de désadaptation d'impédance. L'énergie qui n'est pas transmise à la charge est alors réfléchie vers la source, ce qui induit deux problèmes majeurs: Une perte d'efficacité car une partie de la puissance transmise n'est tout simplement pas rayonnée et un danger pour la source qui peut être endommagée par cette reflexion.

Pour obtenir ce transfert de puissance maximal, l'impédance de la charge doit être le conjugué complexe de l'impédance de la source. Malheureusement, ce cas idéal n'arrive que très rarement en pratique. Il faut alors insérer un circuit d'adaptation entre la source et la charge. Le rôle de ce circuit est de transformer l'impédance de la charge pour qu'elle soit adaptée à sa source.

TODO : FAIRE UN SCHéMA EXPLIQUANT LE CONJUGUE COMPLEXE

=== Quantifier la reflexion

Cette désadaptation est quantifiable mathématiquement avec le coéfficient de réflexion gamma ($Gamma$). Ce coefficient est calculé avec cette formule-ci : 

#align(center, $Gamma = frac(Z_L - Z_0,Z_L + Z_0)$)

Ou $Z_L$ est l'impédance de la charge et $Z_0$ est l'impédance de la source (50 Ohm dans les cas les plus courants). Avec cette formule on peut voir que si l'impédance de la source et de la charge sont les même, on obtient alors 0, une adaptation parfaite. Alors qu'inversement plus la différence entre $Z_0$ et $Z_L$ est grande, plus on se rapprochera d'un coefficient qui se rapproche du 1 ou -1, une réflexion alors totale de l'énergie.

=== Représentation graphique






== Sources (à mettre plus tard dans la bibliographie)

https://www.tme.eu/ch/fr/news/library-articles/page/57276/impedance-comment-elle-est-calculee-et-pourquoi-est-elle-importante-/
https://www.youtube.com/watch?v=EoSJ1M--npg

