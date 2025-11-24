= Planification <planification>
== Planification initiale <planification-initiale>

Ce document détaille la planification semaine par semaine pour la réalisation du travail de bachelor. Le projet se déroule à temps plein sur une période de 10 semaines, avec un rendu final fixé au *vendredi 16 janvier 2026 à 12h00*. La planification intègre des phases de développement, de test, de rédaction et une marge de sécurité pour les imprévus.

== Planification semaine par semaine

=== Semaine 1 du 03.11.2025 au 09.11.2025

Durant la première semaine de travail, l'idée est de se focaliser sur les aspects techniques et théoriques de l'abaque de Smith, comprendre ses enjeux et son utilisation. Un début de rédaction du rapport est aussi nécessaires avec l'aspect historique et une analyse des différents outils possible à utiliser pour la conception du logiciel de l'abaque de Smith. 

Finalement à la fin de la semaine, un framework doit être choisi pour ensuite commencer à mettre en place les différentes étapes du développement.

=== Semaine 2 du 10.11.2025 au 16.11.2025 : Prise en main et bases
- Gestion et validation de la planification totale.
- Début de la conception du projet avec un diagramme de classe UML.
- Prise en main de l'outil JavaFX et mise en place des éléments clés :
  - Dessin de l'abaque de Smith. 
  - Ajout manuel d'impédances sur l'abaque.
  - Système de mémoire pour les points ajoutés.

=== Semaine 3 du 17.11.2025 au 23.11.2025 : Interaction de base sur l'abaque
- Dessin du chemin du circuit en fonction des éléments ajoutés (inductance, capacité, série/shunt).
- Implémentation du curseur magnétisé sur les points calculés.
- Affichage des informations du curseur dans une fenêtre dédiée (“Cursor”) comme Smith.exe le fait.
- Amélioration du rapport intermédiaire.

=== Semaine 4 du 24.11.2025 au 30.11.2025 : Finalisation de l'interface et jalon
- *Rendu du rapport intermédiaire le 25 novembre.*
- Affichage schématique du circuit avec ses composants.
- Implémentation des fonctions de *Zoom* et *Pan* paramétrables pour la navigation.
- Ajout des composants manquants, resistances, lignes et stubs avec leurs comportements respectifs. 
- Amélioration générale de l'interface graphique.

=== Semaine 5 du 01.12.2025 au 07.12.2025 : Gestion des données (Import)
- Charger et afficher les fichiers S-parameter (S1p).
- Recherche sur la structure du format de fichier S1p.
- Création d'un parser pour lire et interpréter les données.
- Traduction des données en points sur l'abaque.

=== Semaine 6 du 08.12.2025 au 14.12.2025 : Fonctionnalités avancées
- Implémentation de la fonction de *Sweep* (balayage en fréquence).
- Développement de la fonction de *Tuning* de base (ajustement des valeurs).
- Mise à jour du diagramme de classe UML pour refléter l'architecture actuelle.

=== Semaine 7 du 15.12.2025 au 23.12.2025 : Export data et rédaction du rapport
- Implémentation de l'export de fichiers S1p issus d'un sweep.
- Recherche et implémentation des notations utilisant les valeurs normalisée CEI 60063. 
- Début de la rédaction du rapport final sur la base du rapport intermédiaire, début d'écriture des parties liées à l'implémentation et à l'architecture.

=== Semaine 8 du 24.12.2025 au 30.12.2025 : Finalisation des fonctionnalités et tests
- Permettre la gestion de plusieurs circuits simultanément en partant du même projet, garder la même base source, charge.
- (Optionnel si le temps est disponible) Ajouter les options de personnalisation de l'interface (couleurs, etc.).
- Début d'une phase de tests et de debuggage de l'application générale.

=== Semaine 9 du 05.01.2026 au 11.01.2026 : Redaction et correction de problèmes
- Correction des bugs critiques identifiés et amélioration/finalisation des features si besoins.
- Rédaction du corps du rapport (architecture, implémentation, choix techniques).

=== Semaine 10 du 12.01.2026 au 16.01.2026 : Finalisation et rendu
- Finalisation de la rédaction (conclusion, résumé).
- Relecture complète du rapport et préparation de la version finale du code.
- Préparation du rendu.

== Rendu final
Le rendu final du travail de bachelor est fixé au *vendredi 16 janvier 2026, à 18h00 au plus tard*.