//
//  NotesScreenViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import Foundation
import UIKit

protocol NotesScreenDelegate: AnyObject {
    func refreshNote(at id: UUID?)
}

final class NotesScreenViewModel {
    
    var didGoToNextScreen: ((UIViewController) -> Void)?
    var didUpdateCollection: (() -> Void)?
    
    private(set) var textForHeaderLabel = "Notes"
    
    var cellViewModels: [NoteViewCellViewModel] = []
    private var notes: [Note] = [] {
        didSet {
            cellViewModels = notes.map { NoteViewCellViewModel(titleNote: $0.title, textNote: $0.content, dateCreated: $0.dateCreated, dateModified: $0.dateModified) }
        }
    }
    
    init() {
        getNotes()
        notes.forEach { note in
            CoreDataManager.shared.deleteNote(note)
        }
    }
    
    func createNote() {
        let newNote = CoreDataManager.shared.createNote()
        notes.insert(newNote, at: 0)
        goToEditNote(newNote)
    }
    
    func editNote(at index: Int) {
        let note = notes[index]
        goToEditNote(note)
    }
    
    func goToEditNote(_ note: Note) {
        let viewModel = CreateNoteViewModel(note: note)
        viewModel.delegate = self
        let viewController = CreateNoteViewController(with: viewModel)
        didGoToNextScreen?(viewController)
    }
    
    private func updateNote(at index: Int) {
        cellViewModels[index].titleNote = notes[index].title
        cellViewModels[index].textNote = notes[index].content
    }
    
    private func indexForNote(id: UUID?) -> Int {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return 0 }
        return index
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

extension NotesScreenViewModel: NotesScreenDelegate {
    func refreshNote(at id: UUID?) {
        let index = indexForNote(id: id)
        cellViewModels[index].
    }
}

