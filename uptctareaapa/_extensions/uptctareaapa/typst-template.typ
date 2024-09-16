
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#let config = ( 
  page: (
    paper: "us-letter",
    margin: (
      top: 2.5cm,
      left: 2.5cm,
      bottom: 2.5cm,
      right: 2.5cm,
    ),
    header-ascent: 40%,
  ),
  fonts: (
    sans_serif: "IBM Plex Sans",
    serif: "Schibsted Grotesk",
    mono: "",
    math: "",
    headings: "IBM Plex Sans",
    body: "IBM Plex Sans",
    page_number: "Schibsted Grotesk",
    base_size: 11pt,
  ),
  text: (
    lang: "es",
    region: "ES",
  ),
  paragraph: (
    line_spacing: 1.4em,
    first_line_indent: 1.27cm,
  ),
  asignatura: none,
  universidad: none,
  facultad: none,
  escuela: none,
  fecha: none,
)


// IBM Plex Sans,  Schibsted Grotesk

#let encabezado(config: none, doc) = {
  set align(right)
  set text(size: config.fonts.base_size * 0.8, weight: 300, font: config.fonts.page_number)
  counter(page).display()
  doc
}

#let obtener_suplemento(it) = {

  if it.kind == image {
      [Figura]
  } else if it.kind == table {
      [Tabla]
  } else if  it.kind == raw {
      [Listado]
  } else {
    it.kind
  }
}

#let configurar_figuras(config: none, figura) = {
  show figure: set block(breakable: false, width: 100%, spacing: config.paragraph.line_spacing)

  show figure.caption: it => {
    set align(left)
    set par(first-line-indent: 0em)
    v(config.paragraph.line_spacing)
    text(weight: 600, it.supplement + " " + it.counter.display(it.numbering) + ": ")
    text(style: "italic", it.body)
  }
  
  show figure: set figure.caption(position: top)
  // show figure: it => {
  //   set placement(top)
  // }
  set image(fit: "contain")

  figura.caption 
  align(center, figura.body)
}


#let configurar_texto_base(config: none, doc) = {
  // Configurar Idioma
  set text(lang: config.text.lang, region: config.text.region)

  // Configurar Títulos
  show heading: set text(size: config.fonts.base_size * 1.5, font: config.fonts.headings, weight: 700)
  show heading: set block(above: 3em, below: 2em)
  show heading: set align(left)
  show heading.where(level: 1): it => {
    set align(center)
    it
  }

  // Configurar Cuerpo de Texto
  set text(size: config.fonts.base_size, font: config.fonts.body)

  // Configurar párrafos
  set align(left)
  set par(
    leading: config.paragraph.line_spacing, 
    first-line-indent: config.paragraph.first_line_indent, 
    justify: false)
  show par: set block(spacing: config.paragraph.line_spacing)
  
  //show ref: it => obtener_suplemento(it)

  doc
}

#let configurar_texto_preliminares(config: none, doc) = {
  // Configurar textos 
  show: doc => configurar_texto_base(config: config, doc)
  doc
}

#let configurar_texto_cuerpo(config: none, doc) = {
  // Configurar textos 
  show: doc => configurar_texto_base(config: config, doc)  

  // Configurar Títulos
  // ? counter(heading).display()
  // #show heading: underline.with(stroke: 2pt)
  // show heading: set text(size: config.fonts.base_size * 1.5, font: config.fonts.headings, weight: 700, fill: green)
  set heading(numbering: "1.1.") 
  

  doc
}

#let portada(title: none, authors: none, date: none, organization: none, config: none) = {
  // Configurar página
  set page(
    paper: config.page.paper,
    margin: config.page.margin,
    numbering: none,
    header-ascent: config.page.header-ascent,
    header: [#show: encabezado(config: config)[]]
  )
  // Idioma
  set text(lang: config.text.lang, region: config.text.region)
  set text(font: config.fonts.sans_serif, size: config.fonts.base_size,  weight: 400)
  
  // ***** Contenido *****
  set align(center)

  // Ocultar el título de portada pero mostrarlo como marcador
  {
    set text(size: 0pt)
    heading(level: 1, numbering: none, outlined: false, bookmarked: true, "Portada")
  }

  // Mostrar el título de la tarea
  text(size: 1.5em, weight: 700, upper(title))
  v(3cm)

  // Mostrar los autores
  text(size: 0.8em, "Presentado por:")
  v(2mm)
  for author in authors {
     if author.type == [student] {
      text(author.name) 
    }
    v(0.1cm)
  }

  v(4cm - (authors.len() * 0.1cm))

  text(size: 0.8em, "Docente:")
  v(0.1cm)
  for author in authors {
     if author.type == [professor] {
      text(author.name)
    }
    v(0.1cm)
  }

  v(0.5cm)
  text(size: 0.8em, "Asignatura:")
  v(0.1cm)
  text(organization.subject)

  v(3cm)
  image("logo-uptc.png", width: 26%)

  v(0.5cm)
  text(organization.university)

  v(0cm)
  text(organization.faculty)

  v(0cm)
  text(organization.school)

  v(0cm)
  text(organization.program)

  v(0cm)
  text(date)
  v(0.1cm)
}

#let preliminares(toc: true, doc) = {
  // Configurar Página
  set page(
    paper: config.page.paper,
    margin: config.page.margin,
    numbering: none,
    header-ascent: config.page.header-ascent,
    header: [#show: encabezado(config: config)[]],
  )

  // Configurar textos 
  show: doc => configurar_texto_preliminares(config: config, doc)

  // Configurar figuras
  show figure: it => [#configurar_figuras(config: config, it)]

  // Mostrar las tablas de contenidos
  if toc == true {

    // Mostrar Tabla de Contenido  
    heading(level: 1, numbering: none, outlined: false, bookmarked: true, "Contenido")
    outline(
      title: "",
      indent: 2em
    )
    pagebreak()
    
    // Mostrar Lista de Figuras 
    locate(loc => {
      if query(figure.where(kind: image), loc).len() > 0 {
        heading(level: 1, numbering: none, outlined: false, bookmarked: true, "Lista de Figuras")
        outline(title:"", target: figure.where(kind: image),)
        pagebreak()
      }
    })

    // Mostrar Lista de Tablas 
    locate(loc => {
      if query(figure.where(kind: table), loc).len() > 0 {
        heading(level: 1, numbering: none, outlined: false, bookmarked: true, "Lista de Tablas")
        outline(title:"", target: figure.where(kind: table),)
        pagebreak()
      }
    })

  }

  doc
}

#let cuerpo(doc) = {
  {
    set page(
      paper: config.page.paper,
      margin: config.page.margin,
      numbering: none,
      header-ascent: config.page.header-ascent,
      header: [#show: encabezado(config: config)[]]
    )

    show: doc => configurar_texto_cuerpo(config: config, doc)
    
    // Configurar figuras
    show figure: it => [#configurar_figuras(config: config, it)]

    doc
  }
}

#let posteriores(bibliography-file: none, doc) = {
  {
    set page(
      paper: config.page.paper,
      margin: config.page.margin,
      numbering: none,
      header-ascent: config.page.header-ascent,
      header: [#show: encabezado(config: config)[]]
    )

    // Idioma
    set text(lang: config.text.lang, region: config.text.region)

    // Configurar Títulos
    // ? counter(heading).display()
    // #show heading: underline.with(stroke: 2pt)
    show heading: set text(size: config.fonts.base_size * 1.5, font: config.fonts.headings)
    set heading(numbering: "1.1.")  
    show heading: set align(left)

    // Nivel 1
    show heading.where(level: 1): it => {
      set align(center)
      set text(fill: black)
      it
    }

    // Configurar párrafos
    set align(left)
    set par(justify: false)
    
    // Configurar figuras
    show figure: it => [#configurar_figuras(config: config, it)]

    doc

    // Bibliografía
    if bibliography-file != none {
      set par(justify: false, first-line-indent: 0cm)
      bibliography(bibliography-file, full: true, style: "american-psychological-association")
    }
  }
}


#let article(
  title: none,
  authors: none,
  organization: none,
  date: none,
  lang: none,
  region: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  subject: none,
  doc,
) = {

  portada(title: title, authors: authors, date: date, organization: organization, config: config)

  //show: doc => preliminares(config: config, doc)
  
  //pagebreak()
  



  // set page(
  //   paper: paper,
  //   margin: margin,
  //   numbering: "1",
  // )
  // set par(justify: true)
  // set text(lang: lang,
  //          region: region,
  //          font: font,
  //          size: fontsize)
  // set heading(numbering: sectionnumbering)

  // if title != none {
  //   align(center)[#block(inset: 2em)[
  //     #text(weight: "bold", size: 1.5em)[#title]
  //   ]]
  // }

  // if authors != none {
  //   let count = authors.len()
  //   let ncols = calc.min(count, 3)
  //   grid(
  //     columns: (1fr,) * ncols,
  //     row-gutter: 1.5em,
  //     ..authors.map(author =>
  //         align(center)[
  //           #author.name \
  //           #author.affiliation \
  //           #author.email
  //         ]
  //     )
  //   )
  // }

  // if date != none {
  //   align(center)[#block(inset: 1em)[
  //     #date
  //   ]]
  // }

  // if abstract != none {
  //   block(inset: 2em)[
  //   #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
  //   ]
  // }

  // if toc {
  //   let title = if toc_title == none {
  //     auto
  //   } else {
  //     toc_title
  //   }
  //   block(above: 0em, below: 2em)[
  //   #outline(
  //     title: toc_title,
  //     depth: toc_depth,
  //     indent: toc_indent
  //   );
  //   ]
  // }

  // if cols == 1 {
  //   doc
  // } else {
  //   columns(cols, doc)
  // }
  doc
}

// #set table(
//   inset: 6pt,
//   stroke: none
// )

