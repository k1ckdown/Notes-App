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
    
    var showContentPlaceholder: ((String) -> Void)?
    var hideContentPlaceholder: (() -> Void)?
    var showKeyboard: (() -> Void)?
    
    weak var delegate: NotesScreenDelegate?
    
    // MARK: - Private properties
    
    private var note: Note?
    private let contentPlaceholder = "Your new note..."
    
    // MARK: - Inits
    
    init(note: Note?) {
        self.note = note
    }
    
    // MARK: - Public methods
    
    func shouldShowKeyboard() {
        if note == nil {
            showKeyboard?()
        }
    }
    
    func shouldShowContentPlaceholder(content: String) {
        if content.isBlank {
            showContentPlaceholder?(contentPlaceholder)
        } else if content == contentPlaceholder {
            hideContentPlaceholder?()
        }
    }
    
    func shouldDeleteNote(with title: String?, and text: String?) {
        guard let title = title, let text = text else { return }
        
        if title.isBlank && (text.isBlank || text == contentPlaceholder) {
            deleteNote(note: note)
        }
    }
    
    func shouldSaveNote(with title: String?, and text: String?) {
        guard let newTitle = title, let newText = text else { return }
        guard let note = note else {
            createNote(title: newTitle, text: newText)
            return
        }
        
        updateNote(note: note, title: newTitle, text: newText)
    }
    
    func getTitle() -> String {
        guard let title = note?.title else { return "" }
        return title
    }
    
    func getText() -> String {
        guard let content = note?.content else { return ""}
        guard !content.isBlank else { return "" }
        return content
    }
    
    // MARK: - Private methods
    
    private func deleteNote(note: Note?) {
        guard let note = note else { return }
        
        delegate?.deleteNote(with: note.id)
        NoteService.shared.deleteNote(note) { result in
            switch result {
            case .success():
                return
            case .failure(let error):
                delegate?.showError(desc: error.errorDescription)
            }
        }
    }
    
    private func createNote(title: String, text: String) {
        if title.isBlank && (text.isBlank || text == contentPlaceholder) { return }
        let content = text == contentPlaceholder ? "" : text
        
        NoteService.shared.createNote(title: title,
                                      content: content,
                                      dateCreated: Date(),
                                      dateModified: Date()) { result in
            switch result {
            case .success(let note):
                self.note = note
                delegate?.addNewNoteInCollection(note: note)
            case .failure(let error):
                delegate?.showError(desc: error.errorDescription)
            }
        }
    }
    
    private func updateNote(note: Note, title: String, text: String) {
        let content = text == contentPlaceholder ? "" : text
        guard let oldTitle = note.title, let oldText = note.content else { return }
        if title == oldTitle && content == oldText { return }
        
        NoteService.shared.updateNote(note: note,
                                      title: title,
                                      content: content,
                                      dateModified: Date()) { result in
            switch result {
            case .success(let note):
                self.note = note
                delegate?.updateNoteInCollection(with: note.id)
            case .failure(let error):
                self.delegate?.showError(desc: error.errorDescription)
            }
        }
    }
}
