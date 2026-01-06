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
  Ce travail de Bachelor a pour but de développer un logiciel pour faciliter l'utilisation de l'abaque de Smith, qui permet d'effectuer graphiquement une adaptation d'impédance. L'objectif est de proposer un outil plus moderne et surtout multi-plateforme.
  \
  \
  Au terme de ce travail, l'application est pleinement fonctionnelle. Toutes les fonctionnalités demandées dans le cahier des charges ont pu être mises en place. L'application permet d'effectuer manuellement et intuitivement le mécanisme d'adaptation d'impédance, tout en permettant à l'utilisateur de comprendre concrètement l'effet de chaque composant.
  \
  \
  L'utilisateur peut aussi importer et exporter des fichiers S1P, ce qui permet de visualiser et d'adapter le comportement du circuit selon différentes fréquences mesurées ou simulées en temps réel.
  \
  \
  Finalement, à partir des résultats obtenus lors de la simulation, il est possible d'exporter les données vers un fichier pour sauvegarder le travail effectué.
]