#let language = "fr"

#let studentFirstname = "Edwin"
#let studentLastname = "Häffner"

// Use feminine or masculine form in template's text. Example: "La soussignée" or "Le soussigné"
#let TBfeminineForm = false // for the author
#let TBsupervisorFeminineForm = false // same, but for the supervisor. Example: "Enseignante responsable"

#let confidential = false

#let TBtitle = "Editeur d'abaque de Smith "
#let TBsubtitle = "Développement d'un outil moderne et multiplateforme"
#let TByear = "2025"
#let TBacademicYears = "2024-25"

#let TBdpt = "Département des Technologies de l'information et de la communication (TIC)"
#let TBfiliere = "Informatique et systèmes de communication"
#let TBorient = "Informatique logicielle"

#let TBauthor = studentFirstname + " " + studentLastname
#let TBsupervisor = "Prof. Bertrand Hochet"
#let TBindustryContact = "Nom"
#let TBindustryName = "EntrepriseZ"
#let TBindustryAddress = [
  Rue XY\
  1400 Yverdon-les-Bains
]

    
#let TBresumePubliable = [
  Ce travail de Bachelor a pour but de développer un logiciel pour faciliter l'utilisation de l'abaque de Smith, qui permet d'effectuer graphiquement une adaptation d'impédance. L'objectif est de proposer un outil plus moderne et surtout multi-plateforme qui permet à l'utilisateur de comprendre ce qu'il fait, à l'instar des outils de simulation automatique.
  \
  \
  Au terme de ce travail, l'application est pleinement fonctionnelle. Les fonctionnalités principales demandées dans le cahier des charges ont pu être mises en place. L'application permet d'effectuer manuellement et intuitivement le mécanisme d'adaptation d'impédance en plaçant des composants passifs (R, L, C, lignes de transmission, stubs) en série ou en parallèle. L'utilisateur peut visualiser en temps réel les trajectoires sur l'abaque ainsi que le schéma électrique du circuit, accompagnés des paramètres calculés (VSWR, Return Loss, coefficient de réflexion,...).
  \
  \
  L'utilisateur peut importer et exporter des fichiers S1P, ce qui permet de visualiser et d'adapter le comportement du circuit selon différentes fréquences mesurées ou simulées. L'outil permet de mettre en évidence jusqu'à trois bandes de fréquences sur le fichier S1P et permet la visualisation en temps réel de chaque modification du circuit d'adaptation sur l'entièreté des points affichés sur l'abaque. La fonction de balayage fréquentiel (sweep) permet d'analyser la réponse du circuit sur une plage de fréquences, et les résultats peuvent être exportés au format S1P pour une réutilisation ultérieure.
  \
  \
  Finalement, l'application offre des outils pratiques comme le tuning des composants, l'utilisation d'un catalogue de composants normalisés CEI 60063 créé par l'utilisateur, la prise en compte du facteur de qualité des composants pour des simulations plus réalistes, la gestion de l'historique (undo/redo), et la sauvegarde complète des projets sur lesquels travaille l'utilisateur.
]