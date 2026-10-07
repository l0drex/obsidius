// use tailwind colors: text 700, fill 100, stroke 300
#let emptyblock((fontcolor, bgcolor, bordercolor), content) = {
  set text(fill: fontcolor)
  block(width: 100%, inset: (x: 1em, y: 0.5em), radius: 0.5em, breakable: false,
    fill: bgcolor, stroke: (paint: bordercolor, thickness: 1pt), content)
}

#let callout(icon, title, content, colors) = {
  emptyblock(colors,
  [
    #icon #strong(title)

    #content
  ])
}

#let inactive-text-color = rgb("#98A1AE")

#let notes(title, content) = {
  // meta information
  set document(title: title)

  // page layout and style
  set page(numbering: "1", header: context {
    let h = query(heading.where(level: 1).after(here())
      .or(heading.where(level: 1).before(here())))
      .at(0, default: (body: []))


    set text(fill: inactive-text-color)
    set align(center)
    emph([
      #document.title
      #if h.body != [] [/]
      #h.body
    ])
  })

  set text(font: "Noto Sans")

  set heading(numbering: "1.")
  show heading: set text(weight: "extrabold")
  /*#show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }*/

  show figure.caption: set text(rgb("#98A1AE"))

  show ref: it => {
    set text(fill: inactive-text-color)
    [_(see #it)_]
  }
  show terms.item: it => {
    callout(emoji.book.open, it.term, it.description,
      (rgb("#1769A7"), rgb("#DFF1FD"), rgb("#73D3FE")))
  }

  set quote(block: true)
  show quote.where(block: true): it => {
    let title = if it.attribution == none [
      Quote
    ] else {
      it.attribution
    }

    callout(emoji.bubble.speech.r, title, it.body,
      (rgb("#354052"), rgb("#F3F3F5"), rgb("#D1D4DC")))
  }

  set table(stroke: rgb("#E4E6EB") + 0.5pt, fill: (_, y) => if calc.odd(y){ rgb("#F9F9FB") })
  show table.cell.where(y: 0): set text(weight: "bold")
  show table: set align(start)

  show raw: set text(font: "Noto Sans Mono")
  show raw.where(block: true): it => {
    emptyblock((black, rgb("#F9F9FB"), rgb("#F3F3F5")), {
      place(top+right, text(font: "Noto Sans", fill: inactive-text-color, it.lang))
      it
    })
  }

  content
}

#let fact(body) = callout(
  emoji.lightbulb,
  "Fact",
  body,
  (oklch(55.4%, 0.135, 66.442deg), oklch(97.3%, 0.071, 103.193deg), oklch(90.5%, 0.182, 98.111deg)),
)

#let warning(body) = {
  callout(emoji.warning, "Warning", body,
    (oklch(55.3%, 0.195, 38.402deg), oklch(95.4%, 0.038, 75.164deg), oklch(83.7%, 0.128, 66.29deg)))
}

#let solution(body) = {
  callout(emoji.checkmark.box, "Solution", body,
    (oklch(52.7%, 0.154, 150.069deg), oklch(96.2%, 0.044, 156.743deg), oklch(87.1%, 0.15, 154.449deg)))
}

#let questions(body) = {
  set text(fill: inactive-text-color)
  [
    *Questions*
    #body
  ]
}
