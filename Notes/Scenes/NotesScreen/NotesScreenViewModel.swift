//
//  NotesScreenViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import Foundation
import UIKit

protocol NotesScreenDelegate: AnyObject {
    func refreshNote(with id: ObjectIdentifier)
    func deleteNote(with id: ObjectIdentifier)
}

final class NotesScreenViewModel {
    
    // MARK: - Public properties
    
    var didGoToNextScreen: ((UIViewController) -> Void)?
    var didUpdateCollection: (() -> Void)?
    
    var cellViewModels: [NoteViewCellViewModel] = []
    
    // MARK: - Private properties
    
    private var notes: [Note] = [] {
        didSet {
            cellViewModels = notes.map { NoteViewCellViewModel(titleNote: $0.title,
                                                               textNote: $0.content,
                                                               dateCreated: $0.dateCreated,
                                                               dateModified: $0.dateModified) }
        }
    }
    private(set) var textForHeaderLabel = "Notes"
    
    // MARK: - Inits
    
    init() {
        getNotes()
    }
    
    // MARK: - Public methods
    
    func createNote() {
        let newNote = CoreDataManager.shared.createNote()
        notes.insert(newNote, at: 0)
        goToEditNote(newNote)
    }
    
    func editNote(at index: Int) {
        let note = notes[index]
        goToEditNote(note)
    }
    
    // MARK: - Private methods
    
    private func indexForNote(id: ObjectIdentifier) -> Int {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return 0 }
        return index
    }
    
    private func goToEditNote(_ note: Note) {
        let viewModel = CreateNoteViewModel(note: note)
        viewModel.delegate = self
        let viewController = CreateNoteViewController(with: viewModel)
        didGoToNextScreen?(viewController)
    }
    
    private func updateNote(at index: Int) {
        let note = notes[index]
        cellViewModels[index] = NoteViewCellViewModel(titleNote: note.title,
                                                      textNote: note.content,
                                                      dateCreated: note.dateCreated,
                                                      dateModified: note.dateModified)
    }
    
    private func getNotes() {
        CoreDataManager.shared.fetchNotes { [weak self] result in
            switch result {
            case .success(let notes):
                self?.notes = notes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - NotesScreenDelegate

extension NotesScreenViewModel: NotesScreenDelegate {
    func refreshNote(with id: ObjectIdentifier) {
        let index = indexForNote(id: id)
        updateNote(at: index)
        didUpdateCollection?()
    }
    
    func deleteNote(with id: ObjectIdentifier) {
        let index = indexForNote(id: id)
        notes.remove(at: index)
        didUpdateCollection?()
    }
}

