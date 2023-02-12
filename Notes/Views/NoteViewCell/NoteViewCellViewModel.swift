//
//  NoteViewCellViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import Foundation

final class NoteViewCellViewModel {
    
    // MARK: - Private properties
    
    private(set) var titleNote: String
    private(set) var textNote: String
    private(set) var dateCreated: String
    private(set) var dateModified: String
    
    // MARK: - Inits
    
    init(titleNote: String?, textNote: String?, dateCreated: String?, dateModified: String?) {
        self.titleNote = titleNote ?? ""
        self.textNote = textNote ?? ""
        self.dateCreated = dateCreated ?? ""
        self.dateModified = dateModified ?? ""
    }
}
