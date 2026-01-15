= Guide d'utilisation et installation <guide-utilisation>

== Installation

=== Prérequis système

JSmithFX utilise JavaFX 25, qui nécessite la version de *Java 23 ou supérieur* pour fonctionner. L'application ne peut pas s'exécuter sur des versions antérieures (comme Java 8, 11, 17 ou 21).

*Pour les utilisateurs finaux* : Le JRE (Java Runtime Environment) 23 ou supérieur est suffisant.
\
*Pour les développeurs* : Le JDK (Java Development Kit) 23 ou supérieur est nécessaire.

==== Spécificités Linux

Sur les systèmes Linux, JavaFX s'appuie sur GTK 3. Une version *3.20 ou supérieure* est requise#footnote("Tiré de : https://openjfx.io/highlights/25/"). Une exception sera levée au démarrage si cette dépendance est manquante ou obsolète.

Pour vérifier votre version de GTK 3 (commande variable selon la distribution) :
```bash
gtk-launch --version
# ou
dpkg -l libgtk-3-0
```

=== Installation à partir du fichier JAR

==== Téléchargement

Téléchargez le fichier `JSmithFX-1.0.jar` depuis la page des "Releases" du projet.

==== Lancement de l'application

La méthode recommandée est d'utiliser le terminal pour voir les éventuels messages d'erreur au démarrage. Ouvrez un terminal dans le dossier du fichier `.jar` et exécutez :

```bash
java -jar JSmithFX-1.0.jar
```

Il est aussi possible de lancer l'application en double-cliquant directement dessus, le seul problème est qu'il n'est pas possible de voir s'il y a une erreur avec l'application en l'exécutant de cette façon.

==== Résolution des problèmes courants

- *`java: command not found`* : Java n'est pas installé ou n'est pas dans le `PATH` système.
- *`UnsupportedClassVersionError`* : La version de Java installée est trop ancienne. Tapez `java -version` pour vérifier. Elle doit être $\ge$ 23.

==== Installation du JRE si nécessaire

Si vous n'avez pas Java d'installé ou si votre version est trop ancienne, téléchargez et installez le JRE 25 (version LTS recommandée par rapport au JRE 23) :

*Windows/macOS/Linux :*
- Oracle JRE 25 : https://www.oracle.com/java/technologies/downloads/#jdk25-windows
- Ou Adoptium Temurin JRE 25 (open source) : https://adoptium.net/temurin/releases?version=25

Après installation, vérifiez la version installée :
```bash
java -version
```

Vous devriez voir quelque chose comme `java 25.0.x` ou supérieur.

== Guide de démarrage rapide

=== Projet par défaut au lancement

Au premier lancement, l'application démarre automatiquement avec un projet pré-configuré :
- *Fréquence* : 1 GHz
- *Impédance caractéristique* ($Z_0$) : 50 Ω
- *Impédance de charge* ($Z_L$) : 100 + j150 Ω (point de démonstration)

Le point de charge (LD) est déjà affiché sur l'abaque. Vous pouvez commencer à ajouter des composants directement sans créer de nouveau projet.

=== Modifier les paramètres du projet

Pour changer les valeurs de base :

*Modifier la fréquence :*
1. Menu *Set > Change freq*
2. Entrez la nouvelle fréquence (ex: `2.4 GHz`)

*Modifier l'impédance de charge :*
1. Menu *Set > Change load*
2. Entrez la nouvelle impédance au format cartésien (ex: `75 + j50`$Omega$) ou polaire

*Modifier l'impédance caractéristique :*
1. Menu *Set > Set Characteristic Impedance*
2. Entrez la nouvelle valeur, cette valeur est une valeur réelle en Ohm ($Omega$).

_Note : Modifier ces paramètres recalculera automatiquement toute la chaîne d'impédance du circuit._

=== Créer un nouveau projet vierge

Si vous souhaitez repartir de zéro et effacer tous les composants ajoutés :

1. Menu *File > New*
2. Une boîte de dialogue *"Set Load"* demande l'impédance de charge ($Z_L$) du nouveau projet. Format cartésien ou polaire au choix.
3. Une seconde boîte de dialogue *"Set Frequency"* demande la fréquence de travail.
4. L'abaque se réinitialise complètement, tous les composants sont supprimés et seul le point de charge (LD) reste affiché.

_Attention : Cette opération efface le circuit en cours. Pensez à sauvegarder votre projet avant si nécessaire._

=== Ajouter des composants

Il existe deux méthodes pour construire votre circuit d'adaptation :

*Méthode 1 : Ajout visuel (Recommandé)*
1. Dans le panneau de droite "Add Component", sélectionnez le type (ex: `Capacitor`) et la position (`Series` ou `Parallel`).
2. Cliquez sur le bouton *Mouse add*.
3. Déplacez votre souris sur l'abaque. La trajectoire possible du composant s'affiche en temps réel ainsi que la valeur calculée dans le panneau de droite.
4. Cliquez pour valider la position. La valeur du composant est calculée automatiquement et le composant est ajouté au schéma du circuit électrique.
5. Si vous voulez quitter ce mode d'ajout à la souris, appuyez sur `ESC`.

*Méthode 2 : Ajout manuel*
1. Dans le panneau de droite, sélectionnez le type, la position et entrez une valeur précise (ex: `3.3 pF`).
2. Cliquez sur le bouton *Add*.

*Insertion entre composants :*

Vous pouvez insérer un composant à un endroit précis du circuit :
1. Dans le schéma électrique, cliquez sur un des petits cercles gris situés entre les composants (ou au début/fin du circuit).
2. Le point d'insertion sélectionné devient vert.
3. Le prochain composant ajouté sera inséré à cet endroit.

_Note : Pour les lignes de transmission, vous devez spécifier l'impédance caractéristique ($Z_0$) de la ligne et sa permittivité ($epsilon_r$)._

=== Tuning et Modification

==== Tuning
Pour effectuer le "fine-tuning" d'un composant déjà placé :
1. Cliquez sur le composant dans le schéma électrique.
2. Le panneau *Tune Selected Component* apparaît.
3. Utilisez le curseur (slider) pour ajuster la valeur en temps réel et observer le déplacement sur l'abaque.
4. Cliquez sur *Apply* pour valider ou *Cancel* pour revenir à la valeur initiale.
5. Si le composant sélectionné est un composant non parfait, un autre slider apparaît pour aussi tuner la valeur du facteur de qualité pour les inducteurs et les capaciteurs, et la valeur de perte pour les lignes de transmission.

==== Modification

Lorsqu'on clique sur un des composants dans le schéma électrique, le panneau "Add Component" devient "Modify Component" :
1. Vous pouvez complètement changer le type du composant (passer d'un condensateur à une inductance par exemple).
2. Vous pouvez changer sa position (série ↔ parallèle).
3. Les modifications se font de la même manière que l'ajout : soit manuellement en entrant une nouvelle valeur, soit visuellement avec *Mouse add*.
4. Pour annuler la modification, cliquez ailleurs ou appuyez sur `ESC`.

=== Informations temps réel (Curseur)

Lorsque vous déplacez votre souris sur l'abaque, le panneau "Cursor Values" du côté droit de l'application affiche les valeurs à la position de la souris en temps réel :
- L'impédance ($Z$) à la position du curseur
- L'admittance ($Y$)
- Le coefficient de réflexion ($Gamma$)
- Le facteur de qualité (Q)
- Le VSWR
- Le Return Loss (en dB)

Lorsque la souris se trouve près d'un point sur l'abaque, les informations se figent sur ce point (tant que la souris reste relativement proche). Utile pour obtenir plus de détails si les informations affichées dans l'onglet DataPoints ou dans la fenêtre contextuelle qui s'affiche ne sont pas suffisantes.

#figure(
  image("../images/affichage_cursor_value_fenêtre.png"),
  caption: [Affichage des valeurs du curseur en temps réel]
)

=== Importer un fichier S1P Touchstone

JSmithFX permet de visualiser des mesures réelles ou simulées :
1. Allez dans le menu *Import/Export > Import S1P*.
2. Sélectionnez votre fichier `.s1p` (Format Touchstone).
3. Le panneau de gestion S1P s'ouvre à droite.
4. Vous pouvez activer jusqu'à 3 filtres de fréquences pour mettre en évidence des bandes spécifiques (*Set > Enable X Frequency Filter*).
5. (Optionnel) Cochez *"As Load"* pour utiliser le fichier S1P comme charge complexe variant avec la fréquence lors de vos simulations. C'est extrêmement utile pour visualiser en direct les changements apportés par le circuit d'adaptation aux mesures fournies par le fichier S1P.

=== Balayage en fréquence (Sweep)

Le sweep permet d'analyser le comportement du circuit sur une plage de fréquences :

1. Construisez votre circuit d'adaptation.
2. Allez dans *Simulation > Frequency Sweep*.
3. Configurez les paramètres du sweep :
   - Fréquence de début 
   - Fréquence de fin
   - Nombre de points 
4. Cliquez sur *OK*. Les points du sweep s'affichent sur l'abaque en violet.
5. Pour exporter les résultats : *Import/Export > Export to S1P* ou bien directement dans le volet `Sweep Management` en cliquant sur le bouton *Export Sweep to S1P*.

=== Cercles VSWR

Pour visualiser des cercles de VSWR constant :

1. Menu *Set > Set Display Circles Options*.
2. Dans la fenêtre qui s'affiche, vous pouvez choisir les cercles de VSWR que vous voulez afficher parmi une sélection de valeurs. Cliquez sur *OK* pour que les cercles s'affichent sur l'abaque.
3. Le ou les cercles apparaissent sur l'abaque. Tous les points à l'intérieur de ce cercle ont un VSWR inférieur à la valeur spécifiée.
4. Pour les enlever, il suffit de retourner dans *Set > Set Display Circles Options* et décocher les cercles non voulus.

=== Gestion de plusieurs circuits

JSmithFX permet de travailler sur plusieurs circuits en parallèle avec la même charge, fréquence de base et impédance caractéristique :

1. En haut de l'interface, au dessus du schéma électrique, vous trouverez un menu déroulant avec les différents indices des circuits du projet suivi de boutons *New*, *Copy* et *Del*.
2. Cliquez sur *New* pour créer un nouveau circuit vierge. Il apparaît dans le menu déroulant.
3. Utilisez le menu déroulant pour basculer entre les différents circuits (0, 1, 2, etc.).
4. Chaque circuit a sa propre liste de composants.
5. Le bouton *Copy* duplique le circuit actuel.
6. Le bouton *Del* supprime le circuit actuel. S'il n'existe qu'un seul circuit, rien ne se passe pour éviter de se retrouver sans circuit.

=== Navigation sur l'abaque (Zoom & Pan)

Pour mieux visualiser une zone précise de l'abaque :

*Zoom :*
- Utilisez la molette de la souris pour zoomer/dézoomer.
- Le zoom se fait autour de la position du curseur.
- Le zoom peut aussi se faire avec les boutons "+" et "-" dans le panneau de droite, le zoom sera alors centré sur le dernier point du circuit.

*Pan (Déplacement) :*
- Cliquez et glissez sur l'abaque pour déplacer la vue.

*Réinitialiser la vue :*
- Bouton *Reset View* dans le panneau de droite
- Ou double-clic gauche n'importe où sur l'abaque

=== Composants discrets (Catalogue)

Pour travailler avec des composants réels que vous possédez physiquement :

1. Menu *Use discrete components > Configure discrete components*.
2. Dans la fenêtre, ajoutez vos composants disponibles :
   - Sélectionnez le type (Résistance, Condensateur, Inductance)
   - Entrez la valeur
   - (Optionnel) Ajoutez les caractéristiques parasites : Facteur Q ou ESR
   - Cliquez sur *Add to Library*
3. Vous pouvez importer/exporter votre catalogue au format CSV (boutons *Import* et *Export*).
4. Fermez la fenêtre et activez *Use discrete components* dans le menu du même nom.
5. Lors de l'ajout à la souris, des petits points cyan apparaissent sur l'abaque indiquant exactement où se trouvent vos composants disponibles. La valeur se "magnétise" automatiquement sur le composant réel le plus proche.

=== Undo / Redo

Vous pouvez annuler et refaire vos dernières actions :
- *Undo* : `Ctrl+Z` ou menu *Edit > Undo*
- *Redo* : `Ctrl+Y` ou menu *Edit > Redo*

L'historique conserve toutes les opérations d'ajout, modification et suppression de composants.

=== Sauvegarder et charger un projet

*Sauvegarder :*
1. Menu *File > Save* (ou `Ctrl+S`)
2. Choisissez un nom et un emplacement. Extension : `.jsmfx`
3. Le projet complet est sauvegardé (circuits, composants, paramètres).
4. Pour sauvegarder un projet déjà existant dans un nouveau fichier, vous pouvez utiliser *Save As*.

*Charger :*
1. Menu *File > Open*
2. Sélectionnez votre fichier `.jsmfx`
3. Le projet se charge avec tous ses circuits.

_Note : Les fichiers S1P importés et les sweeps effectués ne sont pas sauvegardés dans le projet. Seuls les circuits et leurs paramètres le sont. Vous pouvez exporter les sweeps séparément en S1P si besoin._

=== Tableau des points (DataPoints)

Le tableau en bas de l'interface affiche tous les points calculés du circuit :
- Chaque ligne correspond à un composant ou une étape du circuit
- Les colonnes montrent : Label, Impédance (Z), VSWR, Return Loss (dB), Fréquence, Facteur Q
- Cliquez sur une ligne pour la sélectionner et la mettre en évidence sur l'abaque
- Double-cliquez sur une ligne pour modifier la valeur du composant correspondant.

Il est aussi possible d'afficher les valeurs de chaque point d'un fichier S1P importé ou d'un sweep effectué dans la fenêtre Data Points en activant l'option dans le menu *Show > Show Sweep... ou Show S1P...* 

