//
//  NoteViewCellViewModel.swift
//  Notes-App
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
    private(set) var isSelect = false
    
    // MARK: - Inits
    
    init(titleNote: String?, textNote: String?, dateCreated: String?, dateModified: String?) {
        self.titleNote = titleNote ?? ""
        self.textNote = textNote ?? ""
        self.dateCreated = dateCreated ?? ""
        
        if let dateModified = dateModified {
            self.dateModified = dateModified == dateCreated ? "" : dateModified
        } else {
            self.dateModified = ""
        }
    }
    
    // MARK: - Public methods
    
    func updateData(titleNote: String?, textNote: String?, dateModified: String?) {
        self.titleNote = titleNote ?? ""
        self.textNote = textNote ?? ""
        self.dateModified = dateModified ?? ""
    }
    
    func select() {
        isSelect = true
    }
    
    func deselect() {
        isSelect = false
    }
}
