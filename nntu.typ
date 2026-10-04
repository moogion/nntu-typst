#let placeholder_line(
  width: 100%,
  desc: none,
  spacing: 3pt,
  size: 0.8em,
  line_offset: 0.5em,
  line_stroke: 0.3mm,
  style: "italic",
  content: none,
) = {
  box(width: width, stack(
    dir: ttb,
    spacing: spacing,

    content,

    line(length: 100%, start: (0%, line_offset), stroke: line_stroke),

    if desc != none {
      set align(center)

      text(size: size, style: style, desc)
    },
  ))
}

#let fit-to-width(max-text-size: 64pt, min-text-size: 4pt, it) = context {
  let content_size = measure(it)

  layout(size => {
    if content_size.width > 0pt {
      let ratio-x = size.width / content_size.width
      let ratio-y = size.height / content_size.height

      let ratio = if ratio-x < ratio-y {
        ratio-x
      } else {
        ratio-y
      }

      let newx = content_size.width * ratio
      let newy = content_size.height * ratio

      let suggestedtextsize = 1em * ratio

      if suggestedtextsize.to-absolute() > max-text-size {
        suggestedtextsize = max-text-size
      }

      if suggestedtextsize.to-absolute() < min-text-size {
        suggestedtextsize = min-text-size
      }

      set text(size: suggestedtextsize)

      it
    }
  })
}

#let _title_page(
  type: [лабораторной работе],
  title: none,
  number: none,
  option: none,
  descipline: [Проектирование РЭС],
  institute: [Институт радиоэлектроники и информационных технологий],
  department: [Компьютерные технологии в проектировании и производстве],
  teacher_name: none,
  student_name: none,
  student_group: none,
) = {
  set text(
    font: "Liberation Serif",
    size: 12pt,
    hyphenate: false,
    lang: "ru",
  )
  set par(spacing: 0.65em * 1.5)

  set align(center)

  [
    #set text(size: 12pt, weight: "bold")

    #text(size: 10pt, upper[
      Минобрнауки России \
      Федеральное государственное бюджетное образовательное \
      учреждение высшего образования
    ])

    #par(leading: 0.65em * 1.5, upper[
      "Нижегородский Государственный Технический \
      Университет им. Р.Е. Алексеева"
    ])

    #align(
      left,
      image(
        height: 3em * 3,
        "assets/university_mark.jpg",
      ),
    )
  ]

  v(1fr)

  [
    #institute \
    Кафедра "#department"
  ]

  v(1fr)

  [
    #text(size: 18pt, weight: "bold")[
      Отчет по #type
      #if number != none [№#number]
    ]

    #underline(title)

    #if option != none [вариант №#option]
    по дисциплине "#descipline"
  ]

  v(1fr)

  align(
    right,
    block(width: 50%)[
      #set text(size: 12pt)

      #grid(
        columns: (1fr, 1.5fr),
        inset: 0.8em,
        align: (left + bottom, right + bottom),

        grid.cell(colspan: 2, align: center, strong[СТУДЕНТ]),

        placeholder_line(desc: [(подпись)]),
        placeholder_line(
          content: align(center, student_name),
          desc: [(фамилия, и., о.)],
        ),

        placeholder_line(
          desc: [(дата)],
        ),
        placeholder_line(
          content: align(center, student_group),
          desc: [(группа или шифр)],
        ),

        grid.cell(colspan: 2, align: center, strong[ПРЕПОДАВАТЕЛЬ]),

        placeholder_line(
          desc: [(подпись)],
        ),
        placeholder_line(
          content: align(center, teacher_name),
          desc: [(фамилия, и., о.)],
        ),

        grid.cell(colspan: 2, align: right, placeholder_line(
          width: 65%,
          desc: [(дата)],
        )),
      )
    ],
  )

  table(
    columns: (2fr, 1fr, 1fr, 1.5fr),

    table.header(emph[Комментарии], emph[Дата сдачи], emph[Дата проверки], emph[Отметка о выполнении]),

    [~], [~], [~], [~],
    [~], [~], [~], [~],
    [~], [~], [~], [~],
  )

  v(2fr)

  [Нижний Новгород #datetime.today().year() г.]
}

#let _main_frame(paper: "a4", copier: none) = {
  set text(font: "GOST", style: "italic")

  place(
    dx: 20mm,
    dy: 5mm,
    rect(
      width: 100% - (20mm + 5mm),
      height: 100% - (5mm + 5mm),
      stroke: 0.5mm,
    ),
  )

  let ldx = 20mm - (5mm + 7mm)
  place(
    dx: ldx,
    dy: 100% - 5mm,
    box(
      width: 100% - (ldx + 5mm),
      height: 5mm,
    )[
      #h(2fr)
      Копировал #copier
      #h(1fr)
      Формат #upper(paper)
    ],
  )
}

#let _additional_fields(
  inv_number: none,
  acceptance_sign: none,
  exchange_number: none,
  duplicate_number: none,
  duplicate_sign: none,
  optional: false,
  ref_number: none,
  first_use: none,
) = {
  set text(font: "GOST", style: "italic")

  let ldx = 20mm - (5mm + 7mm)
  if optional {
    place(
      dx: ldx,
      dy: 100% - 5mm - 287mm,
      rotate(
        -90deg,
        reflow: true,
        grid(
          columns: (60mm, 60mm),
          rows: (5mm, 7mm),
          align: center + horizon,
          stroke: 0.5mm,
          [Справ. №], [Перв. примен.],
          ref_number, first_use,
        ),
      ),
    )
  }

  let table = rotate(
    -90deg,
    reflow: true,
    grid(
      columns: (25mm, 35mm, 25mm, 25mm, 35mm),
      rows: (5mm, 7mm),
      align: center + horizon,
      stroke: 0.5mm,
      [Инв. № подл.], [Подп. и дата], [Взам. инв. №], [Инв. № дубл.], [Подп. и дата],
      inv_number, acceptance_sign, exchange_number, duplicate_number, duplicate_sign,
    ),
  )

  context {
    place(
      dx: ldx,
      dy: 100% - measure(table).height - 5mm,
      table,
    )
  }
}

#let _first_main_fields(
  name: none,
  designation: none,
  organization: none,
  developer: (:),
  auditor: (:),
  std_control: (:),
  approver: (:),
  letters: (),
) = context {
  set text(font: "GOST", style: "italic")

  let person_def = (
    name: none,
    sign: none,
    date: none,
  )

  let developer = person_def + developer
  let auditor = person_def + auditor
  let std_control = person_def + std_control
  let approver = person_def + approver

  let letters_def = (
    none,
    none,
    none,
  )

  let letters = letters_def + letters

  let table = grid(
    columns: (7mm, 10mm, 23mm, 15mm, 10mm, 70mm, 5mm, 5mm, 5mm, 15mm, 20mm),
    rows: (5mm,) * 8,
    align: center + horizon,
    inset: .2em,
    stroke: 0.5mm,

    [~],
    [~],
    [~],
    [~],
    [~],

    grid.cell(colspan: 6, rowspan: 3, fit-to-width(
      designation,
      min-text-size: 12pt,
      max-text-size: 24pt,
    )),

    [~],
    [~],
    [~],
    [~],
    [~],

    [Изм.], [Лист], [№ докум.], [Подп.], [Дата],

    grid.cell(colspan: 2, align: left)[Разраб.],
    grid.cell(align: left, fit-to-width(
      developer.name,
      min-text-size: 12pt,
      max-text-size: 24pt,
    )),
    developer.sign,
    developer.date,

    grid.cell(rowspan: 5, fit-to-width(
      name,
      min-text-size: 12pt,
      max-text-size: 24pt,
    )),

    grid.cell(colspan: 3)[Лит.],
    [Лист], [Листов],

    grid.cell(colspan: 2, align: left)[Пров.],
    grid.cell(align: left, fit-to-width(
      auditor.name,
      min-text-size: 12pt,
      max-text-size: 24pt,
    )),
    auditor.sign,
    auditor.date,

    letters.at(0, default: none),
    letters.at(1, default: none),
    letters.at(2, default: none),

    str(here().page()),
    str(counter(page).final().first()),

    grid.cell(colspan: 2, align: left)[],
    [], [], [],

    grid.cell(colspan: 5, rowspan: 3, organization),

    grid.cell(colspan: 2, align: left)[Н.контр.],
    grid.cell(align: left, std_control.name), std_control.sign, std_control.date,

    grid.cell(colspan: 2, align: left)[Утв.],
    grid.cell(align: left, approver.name), approver.sign, approver.date,
  )

  place(
    dx: 100% + 5mm - measure(table).width,
    dy: 100% - measure(table).height - 5mm,
    table,
  )
}

#let _main_fields(
  designation: none,
) = context {
  set text(font: "GOST", style: "italic")

  let table = grid(
    columns: (7mm, 10mm, 23mm, 15mm, 10mm, 110mm, 10mm),
    rows: (5mm, 2mm, 3mm, 5mm),
    align: center + horizon,
    inset: .2em,
    stroke: 0.5mm,

    [~],
    [~],
    [~],
    [~],
    [~],

    grid.cell(rowspan: 4, fit-to-width(
      designation,
      min-text-size: 12pt,
      max-text-size: 24pt,
    )),

    grid.cell(rowspan: 2)[Лист],

    grid.cell(rowspan: 2, none),
    grid.cell(rowspan: 2, none),
    grid.cell(rowspan: 2, none),
    grid.cell(rowspan: 2, none),
    grid.cell(rowspan: 2, none),

    grid.cell(rowspan: 2, counter(page).display()),

    [Изм.], [Лист], [№ докум.], [Подп.], [Дата],
  )

  place(
    dx: 100% + 5mm - measure(table).width,
    table,
  )
}

#let note(paper: "a4", title_page: none, outlined: false, fields: (:), body) = {
  let fields_def = (
    name: none,
    designation: none,
    organization: none,
    developer: none,
    auditor: none,
  )

  let fields = fields_def + fields

  set page(
    paper: paper,
    margin: (
      y: 5mm + 5mm,
      x: 5mm + 5mm,
      left: 20mm + 5mm,
      bottom: 5mm + 3 * 5mm + 5mm,
    ),
    footer-descent: 5mm,
    footer: {
      _main_fields(
        designation: fields.designation,
      )
    },
    background: context {
      _main_frame(
        paper: paper,
      )
      _additional_fields()
    },
  )

  set text(
    font: "Liberation Serif",
    size: 14pt,
    hyphenate: false,
    lang: "ru",
    region: "ru",
  )

  if title_page != none {
    page(
      margin: (bottom: 5mm + 5mm),
      background: {
        _main_frame(
          paper: paper,
        )
      },
      footer: none,
      title_page,
    )
  }

  set par(
    justify: true,
    first-line-indent: (
      amount: 1.25cm,
      all: true,
    ),
  )

  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption.where(position: top): set align(left)

  show figure.where(kind: image): set figure(supplement: [Рисунок])
  set figure.caption(separator: [ --- ])

  show heading: set block(spacing: 1.2em)
  set heading(numbering: "1.1")

  show heading: it => context {
    if it.numbering == none {
      return it
    }

    if par.first-line-indent == none {
      return it
    }

    let target-indent = par.first-line-indent.amount
    let numbering = counter(heading).display(it.numbering)

    let gap = calc.max(
      target-indent - measure(numbering).width,
      0.5em.to-absolute(),
    )

    block(numbering + h(gap) + it.body)
  }

  let heading-numbered = state("nntu-heading-numbered", false)

  show heading.where(numbering: none): set align(center)
  show heading.where(level: 1): it => {
    heading-numbered.update(it.numbering != none)
    counter(math.equation).update(0)
    for kind in (image, table, raw) {
      counter(figure.where(kind: kind)).update(0)
    }

    it
  }

  set math.equation(numbering: (n, ..) => {
    let is-numbered = heading-numbered.get() and counter(heading).get().first() > 0
    if is-numbered {
      numbering("(1.1)", counter(heading).get().first(), n)
    } else {
      numbering("(1)", n)
    }
  })

  set figure(numbering: (n, ..) => {
    let is-numbered = heading-numbered.get() and counter(heading).get().first() > 0
    if is-numbered {
      numbering("1.1", counter(heading).get().first(), n)
    } else {
      numbering("1", n)
    }
  })

  show table: set par(justify: false)

  // show raw.where(block: true): set par(first-line-indent: 0em)
  // show math.equation.where(block: true): set align(left)

  if outlined {
    page(
      footer: context {
        let outline_loc = query(outline).first().location()
        let relative_page = here().page() - outline_loc.page()

        if relative_page > 0 {
          _main_fields(
            designation: fields.designation,
          )
        } else {
          _first_main_fields(
            name: fields.name,
            designation: fields.designation,
            organization: fields.organization,
            developer: fields.developer,
            auditor: fields.auditor,
          )
        }
      },
      {
        figure(
          placement: bottom,
          outlined: false,
          caption: none,
          v(15mm),
        )
        outline(indent: 1.5em)
      },
    )
  }

  show heading.where(level: 1): it => {
    pagebreak(weak: true)

    it
  }

  body
}

#let to-string(it) = {
  if it == none {
    return ""
  }

  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}


#let report(
  type: [лабораторной работе],
  title: none,
  number: none,
  option: none,
  name: none,
  designation: none,
  organization: none,
  descipline: [Проектирование РЭС],
  institute: [Институт радиоэлектроники и информационных технологий],
  department: [Компьютерные технологии в проектировании и производстве],
  body,
) = {
  let student_name = sys.inputs.at(
    "student_name",
    default: none,
  )

  let student_group = sys.inputs.at(
    "student_group",
    default: none,
  )

  let teacher_name = sys.inputs.at(
    "teacher_name",
    default: none,
  )

  note(
    title_page: _title_page(
      type: type,
      title: title,
      number: number,
      option: option,
      descipline: descipline,
      institute: institute,
      department: department,
      teacher_name: teacher_name,
      student_name: student_name,
      student_group: student_group,
    ),
    fields: (
      name: name,
      designation: designation,
      organization: organization,
      developer: (
        name: to-string(student_name)
          .split(
            regex("\s"),
          )
          .first(),
      ),
      auditor: (
        name: to-string(teacher_name)
          .split(
            regex("\s"),
          )
          .first(),
      ),
    ),
    outlined: true,
    body,
  )
}

#let transpose(arr) = {
  assert.ne(type(arr) == array, "arr should be array")
  if arr.len() < 1 { return arr }

  assert.ne(type(arr.first()) == array, "element from arr should be array")
  if arr.first().len() < 1 { return arr }

  range(arr.first().len()).map(index => {
    arr.map(it => it.at(index))
  })
}

#let view_chunks(arr, chunks, placeholder: none, mapper: it => it) = {
  let view = arr.chunks(chunks).map(mapper)

  // add remainder of chunking
  for _ in range(view.first().len() - view.last().len()) {
    view.last().push(placeholder)
  }

  return view
}

// And what did I do that for?
// Typst is not restrictive enough in its calculations
#let itertools_product(..args, repeat: 1) = {
  let elements = args.pos()
  for element in elements {
    assert(type(array) != array)
  }

  assert(type(repeat) == int)
  elements *= repeat

  let indexes = range(elements.len()).map(_ => 0)
  let products = ()

  while true {
    let index = 0

    products.push(
      indexes
        .enumerate()
        .map(((x, y)) => {
          elements.at(x).at(y)
        }),
    )

    indexes.at(index) += 1

    while indexes.at(index) >= elements.at(index).len() {
      indexes.at(index) = 0
      index += 1

      if index >= elements.len() {
        return products
      }

      indexes.at(index) += 1
    }
  }
}

#let np = par.with(first-line-indent: 0pt)
