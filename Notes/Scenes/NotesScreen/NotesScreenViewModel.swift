//
//  NotesScreenViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import Foundation

final class NotesScreenViewModel {
    
    private(set) var textForHeaderLabel = "Notes"
    
    let cellViewModels: [NoteViewCellViewModel]
    let notes = [Note(title: "Title 1", text: """
Определение статьи в Википедии зависит от точки зрения. Не все такие определения являются достаточно чёткими.
                      
                      Наиболее общее понятие — страница. Так называются поименованные записи в базе данных Википедии. Имена страниц относятся к разным пространствам. Все статьи принадлежат основному пространству имён (именуемому иногда «пространством статей»), однако обратное неверно. Перенаправления и страницы значений также встречаются в основном пространстве, однако к статьям обычно не относятся.

                      С точки зрения Правил Википедии заготовки статей являются частным случаем статей. Термин заготовка описывает не сущность объекта, а текущий уровень его качества.

                      С точки зрения движка MediaWiki
                      Движок MediaWiki считает статьями все страницы основного пространства имён, не являющиеся страницами перенаправления и содержащие хотя бы одну внутреннюю ссылку. При этом движок не различает, куда ведут эти ссылки, не умеет отличать ссылки на статьи и ссылки на обсуждения, правила Википедии, и не делает различий между ссылками на существующие и несуществующие страницы. Такой механизм работает при подсчёте общего количества статей, а также при генерации различных служебных отчётов.

                      На странице Служебная:Статистика указывается общее число страниц во всех пространствах и число страниц, которые считаются полноценными статьями. Последнее находится в переменной {{NUMBEROFARTICLES}} движка MediaWiki и в данный момент содержит число 1 892 447 (число страниц в пространстве статей без учёта перенаправлений, в которых содержится хотя бы одна ссылка хотя бы ещё куда-нибудь).

                      С точки зрения связности
                      Статьёй называют озаглавленный связный текст из основного пространства имён, содержание которого отражает одно значение его заголовка.

                      Страницы значений описывают несколько различных значений термина, а страницы перенаправления совсем не содержат связного текста. Ни те, ни другие не попадают под определение статьи.

                      Открытые и неэнциклопедические списки, такие, как списки для координации работ, не могут содержать связного энциклопедического текста (что отличает их от энциклопедических списков). Они представляют собой определённый способ навигации по незавершённым разделам.

                      Целью для исключения страниц значений из числа статей служит необходимость спрямления ссылок, в
""", dateCreated: "Dec 12, 2022", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: ""),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                 Note(title: "Title 2", text: "some text 1", dateCreated: "Feb 18, 2004", dateModified: "Dec 12, 2022"),
                ]
    
    init() {
        cellViewModels = notes.map { NoteViewCellViewModel(titleNote: $0.title, textNote: $0.text, dateCreated: $0.dateCreated, dateModified: $0.dateModified) }
    }
    
}
