= Tests <tests>

JSmithFX étant un outil de calcul, il est nécessaire de vérifier la justesse des opérations mathématiques. Les tests automatisés couvrent les deux classes les plus mathématique du projet : `Complex` pour la gestion des nombres complexes et `SmithCalculator` pour les calculs RF. La bibliothèque JUnit 6.0.2 a été utilisée pour l'implémentation de ces tests.

== Tests de la classe `Complex`

Cette classe gère toutes les opérations sur les nombres complexes utilisés dans le projet. Les tests vérifient :

- Les opérations arithmétiques (addition, soustraction, multiplication, division) avec gestion des exceptions pour la division par zéro.
- Le calcul de magnitude et d'angle pour tous les quadrants du plan complexe.
- La fonction hyperbolique `tanh` nécessaire aux calculs de ligne de transmission.
- L'immutabilité des opérations juste pour être sûr que chaque calcul retourne une nouvelle instance et ne modifie pas les valeurs utilisées.

== Tests de la classe `SmithCalculator`

Cette classe contient la logique centrale des calculs sur l'abaque de Smith. Les tests couvrent :

- Les conversions bidirectionnelles entre $Gamma$ et impédance, incluant les cas limites (centre de l'abaque, court-circuit, circuit ouvert).
- Les conversions aller-retour pour vérifier la cohérence mathématique et qu'il n'y ait pas trop de perte par rapport aux arrondis et aux calculs à virgule flottante.
- Le calcul du VSWR et du Return Loss avec les cas d'adaptation parfaite où leurs valeurs se rapproche de l'infini.
- L'addition d'impédances en parallèle avec diverses configurations.
- La vérification des propriétés physiques : $|Gamma| lt.eq 1$ pour les impédances passives.

== Tests de la classe `TouchstoneS1P`

Le parser de fichiers Touchstone (.s1p) nécessitait des tests pour garantir la compatibilité avec différents formats. En plus des vérifications visuelles avec le logiciel Smith.exe, les tests automatisés vérifient :

- Le parsing de la ligne d'options, en reconnaissant des unités de fréquence (Hz, kHz, MHz, GHz), des formats de données (MA, RI, DB) et des impédances de référence (50Ω, 75Ω, 100Ω).
- La conversion des données avec la lecture correcte des points de fréquence et calcul des paramètres dérivés (impédance, VSWR, Return Loss).
- Test d'un cycle complet d'export vers fichier S1P puis réimport pour vérifier la cohérence des données.
- La robustesse du parser avec la gestion des commentaires, lignes vides et fichiers vides. 

Ces tests couvrent les cas d'usage principaux et les cas limites identifiés même s'ils ne sont sûrement pas exhaustifs, c'est assez pour le cadre de ce travail de Bachelor.

== Tests de validation de circuits complets

Pour valider le comportement global de l'application, plusieurs scénarios de circuits d'adaptation ont été implémentés et comparés avec le logiciel de référence Smith.exe. Chaque scénario teste des configurations spécifiques de composants (inductances, capacités, lignes de transmission, stubs) en série ou en parallèle.

La méthodologie de validation consiste à :
1. Configurer un circuit identique dans JSmithFX et Smith.exe
2. Simuler le circuit avec une charge et une fréquence données
3. Comparer les impédances finales obtenues par les deux logiciels
4. Calculer l'écart relatif entre les résultats

Bien que ces tests ne couvrent pas l'ensemble des combinaisons possibles, tous les types de composants ont été validés dans leurs différentes configurations. Les résultats montrent une bonne concordance avec le logiciel de référence, l'écart maximal observé s'élève à 0.6% sur un circuit à quatre composants (scénario 6 : réseau L avec condensateur shunt, inductance série, ligne de transmission et inductance shunt). 

Concrètement, le retour dans le terminal est celui-ci : 

#align(center, ```bash
Expected:    15.740  +33.918j Ω  (|Z| = 37.392 Ω)
Actual:        15.795  +34.115j Ω  (|Z| = 37.594 Ω)
```)

Cette déviation est sûrement due à des arrondis ou des erreurs intrinsèquement liées aux calculs utilisant les virgules flottantes. De plus, on ne sait pas comment sont implémentées les opérations dans le logiciel Smith.exe. Pour avoir une seconde vérification, j'ai utilisé l'outil en ligne OnlineSmithChart#footnote("Lien du circuit de test : https://onlinesmithchart.com/?circuit=blackBox_75_100_0__shortedCap_1.5_pF_0_0_0__seriesInd_3_nH_0_0__transmissionLine_10_mm_0_50_4.4__shortedInd_8_nH_0_0&frequency=2400"). On y retrouve exactement la même valeur calculée par JSmithFX. 

Ceci dit, des déviations de moins de 1% ne sont pas dramatiques, surtout dans un outil d'adaptation graphique tel que l'abaque de Smith. 


