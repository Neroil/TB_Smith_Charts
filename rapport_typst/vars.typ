#let language = "fr"

#let studentFirstname = "Edwin"
#let studentLastname = "Häffner"

// Use feminine or masculine form in template's text. Example: "La soussignée" or "Le soussigné"
#let TBfeminineForm = false // for the author
#let TBsupervisorFeminineForm = false // same, but for the supervisor. Example: "Enseignante responsable"

#let confidential = false

#let TBtitle = "Editeur d'abaque de Smith "
#let TBsubtitle = "Sous-titre"
#let TByear = "2025"
#let TBacademicYears = "2024-25"

#let TBdpt = "Département des Technologie de l'information et de la communication (TIC)"
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
  Dans ce travail... Ceci est le résumé publiable...
]