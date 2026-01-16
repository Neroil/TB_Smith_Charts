#let affiche(
  content, 
  title: "", 
  dpt: "", 
  filiere_short: "", 
  filiere_long: "", 
  orientation: "", 
  author: "", 
  supervisor: "", 
  industryContact: "", 
  industryName: "",
  main_figure: none 
  ) = {
  // Style
  set heading(numbering: none)
  set text(font: "Arial", size: 14pt)

  show heading.where(level: 1): it => [
    #v(0.4em) #it #v(0.4em)
  ]

  set page(
    paper: "a3",
    numbering: none,
    margin: (top: 35pt, bottom: 25pt, x: 35pt)
  )
  set par(leading: 0.55em, spacing: 0.55em, justify: true)

  // Header
  grid(
    columns: (50%, 50%), 
    align: (left, right),
    image("images/logo_heig-vd-2020.svg", width: 30%),
    text(size: 24pt, [
      *Travail de Bachelor #datetime.today().display("[year]")* \
      *Filière #filiere_short* \
      *Orientation #orientation* \
    ])
  )
  
  v(1%)

  // Title
  align(center, par(justify: false, text(size: 42pt)[*#title*]))

  v(0.5%)

  set par(spacing: 0.7em)
  
  block(
    height: 77%, 
    grid(
      columns: 1,
      rows: if main_figure != none { (auto, 1fr) } else { (1fr) },
      gutter: 20pt, 
      
      if main_figure != none {
        align(center, main_figure)
      },

      columns(2, content)
    )
  )

  set par(spacing: 0.55em)

// Teacher, industry and HES-SO logo
 line(length: 100%)

  align(bottom, grid(
    columns: (50%, 50%), 
    align: (left + top, bottom + right),
    text(size: 12pt)[
      Auteur: #author \
      Prof. responsable: #supervisor \
    ],
    image("images/logo_hes-so.png", width: 25%)
  ))

  v(2%)

  // Footer
  align(bottom + right, text(size: 12pt)[
    *HEIG-VD #sym.copyright #datetime.today().display("[year]") filière #filiere_long*
  ])
}