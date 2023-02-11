//
//  NoteViewCellViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import Foundation

final class NoteViewCellViewModel {
    
    private(set) var titleNote: String
    private(set) var content: String
    private(set) var dateCreated: String
    private(set) var dateModified: String
    
    init(titleNote: String, content: String, dateCreated: String, dateModified: String) {
        self.titleNote = titleNote
        self.textNote = textNote
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
    
}
