/* Vars */
#import "../vars.typ": *

/* Includes */
#import "template/affiche.typ": affiche

#show: affiche.with(
  title: TBtitle, 
  dpt: "ISC",
  filiere_short: "ISC",
  filiere_long: TBfiliere,
  orientation: "ISCS",
  author: TBauthor,
  supervisor: TBsupervisor,
  industryContact: TBindustryContact,
  industryName: TBindustryName,
  main_figure: figure(
    image("../images/overview_general_JSmithFX.png", width: 90%),
    caption: "Interface de JSmithFX : Adaptation d'un fichier S1P Touchstone sur deux bandes de fréquences simultanées."
  )
)

= Contexte et objectifs

L'abaque de Smith, créé en 1939, reste l'outil de référence pour l'adaptation d'impédance dans le domaine de la radiofréquence. Le logiciel actuellement utilisé à l'HEIG-VD (Smith.exe) ne fonctionne que sous Windows et présente certaines limitations techniques et de licence.

Ce travail de Bachelor développe *JSmithFX*, un éditeur d'abaque de Smith moderne et multiplateforme permettant de concevoir intuitivement des circuits d'adaptation, visualiser en temps réel l'effet des composants et exploiter efficacement des fichiers de mesures S1P (Touchstone).


= Fonctionnalités principales

L'application propose un éditeur graphique où l'utilisateur place des composants directement sur l'abaque :

- *Édition intuitive :* Le curseur se magnétise automatiquement sur la trajectoire physique du composant ajouté.
- *Gestion S1P :* Import de mesures S1P Touchstone, filtrage par plages de fréquences et visualisation temps réel.
- *Outils d'analyse :* Sweep fréquentiel, fine-tuning via sliders et catalogue de composants normalisés CEI.
- *Simulation réaliste :* Prise en compte du facteur de qualité (Q) pour les composants passifs et gestion des pertes dans les lignes de transmission.

= Architecture technique

*JavaFX* a été utilisé pour sa portabilité native. Un seul exécutable (.jar) fonctionne sur Windows, Linux et macOS.

L'application suit le pattern *Model-View-ViewModel*. Le modèle encapsule les composants électriques et les calculs physiques. La vue gère le rendu graphique. Le ViewModel centralise l'état avec des *JavaFX Properties* observables.

La stack technologique comprend Java 23+, AtlantaFX (thème), Jackson (JSON) et Gradle.

= Résultats et conclusion

Toutes les fonctionnalités du cahier des charges ont été implémentées. L'outil a déjà été utilisé avec succès dans un projet réel d'adaptation, offrant notamment un gain dans la visualisation de fichiers S1P. L'application reste fluide même avec des milliers de points grâce à un rendu optimisé.

*JSmithFX* modernise efficacement l'outil de l'abaque de Smith pour concevoir des circuits d'adaptation d'impédance.