#import "nntu.typ" as nntu-template

#let report(title: [], number: none, option: none, body) = {
  let student_group = sys.inputs.at(
    "student_group",
    default: none,
  )

  nntu-template.report(
    type: [лабораторной работе],
    title: title,
    number: number,
    option: option,
    name: [Лабораторная работа #number~],
    designation: [
      ЛР-ИРИТ-11.03.03-(#student_group)#if option != none [-#option]
    ],
    institute: [Институт радиоэлектроники и информационных технологий],
    department: [Компьютерные технологии в проектировании и производстве],
    descipline: [Теоретическая электродинамика],
    organization: [
      ИРИТ, каф. КТПП,\
      гр. #student_group
    ],
    body,
  )
}

#show: report.with(
  title: [
    Проектирование широкополосных согласующих цепей на элементах с
    сосредоточенными и распределенными параметрами
  ],
  number: 7,
  option: 12,
)

#for _ in range(5) [
  = #lorem(6)

  #lorem(100)

  #for _ in range(8) [
    == #lorem(6)

    #lorem(100)
  ]
]
