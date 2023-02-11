//
//  EditNoteViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 10.02.2023.
//

import Foundation
import UIKit

final class EditNoteViewModel {
    
    // MARK: - Public properties
    
    var didBeginEditingNote: (() -> Void)?
    var didEndEditingNote: ((String) -> Void)?
    var didShowKeyboard: (() -> Void)?
    
    weak var delegate: NotesScreenDelegate?
    
    // MARK: - Private properties
    
    private let note: Note
    private var isEdited = true
    private let placeholderForContent = "Your new note..."
    
    // MARK: - Inits
    
    init(note: Note) {
        self.note = note
    }
    
    // MARK: - Public methods
    
    func shouldShowKeyboard() {
        guard let title = note.title, let content = note.content else { return }
        
        if title.isEmpty && content.isEmpty {
            didShowKeyboard?()
        }
    }
    
    func shouldSaveNote(with title: String?, and text: String?) {
        guard let noteTitle = note.title, let noteContent = note.content else { return }
        guard let newTitle = title, let newText = text else { return }
        
        if (newText.isEmpty || newText == placeholderForContent) && newTitle.isEmpty {
            deleteNote()
        } else {
            if newTitle == noteTitle && newText == noteContent {
                isEdited = false
            }
            
            createNote(title: newTitle, text: newText)
        }
    }
    
    func beginEditingOfNote(content: String) {
        if content == placeholderForContent {
            didBeginEditingNote?()
        }
    }
    
    func endEditingOfNote(content: String) {
        if content.isEmpty {
            didEndEditingNote?(placeholderForContent)
        }
    }
    
    func getTitle() -> String {
        guard let title = note.title else { return "" }
        return title
    }
    
    func getText() -> String {
        guard let content = note.content else { return placeholderForContent}
        guard !content.isEmpty else { return placeholderForContent }
        return content
    }
    
    func getTextColor() -> UIColor {
        guard let content = note.content else { return .lightGray}
        guard !content.isEmpty else { return .lightGray }
        return .white
    }
    
    // MARK: - Private methods
    
    private func isNewNote() -> Bool {
        guard let title = note.title, let content = note.content else { return true}

        if title.isEmpty && content.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private func deleteNote() {
        delegate?.deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note)
    }
    
    private func createNote(title: String, text: String) {
        if isNewNote() {
            note.dateCreated = Date()
        }
        
        if isEdited {
            note.dateModified = Date()
        }
        
        note.title = title
        note.content = text == placeholderForContent ? "" : text
        
        CoreDataManager.shared.saveContext()
        delegate?.refreshNote(with: note.id)
    }
}
