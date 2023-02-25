//
//  NotesScreenViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 09.02.2023.
//

import Foundation
import UIKit

final class NotesScreenViewModel {
    
    // MARK: - Public properties
    
    var didGoToNextScreen: ((UIViewController) -> Void)?
    var didUpdateCollection: (() -> Void)?
    var didUpdateHeader: ((String) -> Void)?
    var didUpdateNoteLayout: ((UICollectionViewFlowLayout) -> Void)?
    var showReceivedError: ((String) -> Void)?
    
    var cellViewModels: [NoteViewCellViewModel] = []
    
    // MARK: - Private properties
    private var noteLayoutType = NoteLayoutType.gallery
    
    private var notes: [Note] = [] {
        didSet {
            cellViewModels = notes.map { NoteViewCellViewModel(titleNote: $0.title,
                                                               textNote: $0.content,
                                                               dateCreated: $0.dateCreated?.format(),
                                                               dateModified: $0.dateModified?.format()) }
        }
    }
    
    // MARK: - Inits
    
    init() {
        getNotes()
    }
    
    // MARK: - Public methods
    
    func createNote() {
        goToEditNote(nil)
    }
    
    func editNote(at index: Int) {
        let note = notes[index]
        goToEditNote(note)
    }
    
    func setListLayout() {
        noteLayoutType = .list
        didUpdateNoteLayout?(noteLayoutType.layout)
    }
    
    func setGalleryLayout() {
        noteLayoutType = .gallery
        didUpdateNoteLayout?(noteLayoutType.layout)
    }
    
    func getLayout() -> UICollectionViewFlowLayout {
        return noteLayoutType.layout
    }
    
    func updateHeader() {
        let numberOfNotes = notes.count
        let headerText = "\(numberOfNotes) \(numberOfNotes == 1 ? "Note" : "Notes")"
        didUpdateHeader?(headerText)
    }
    
    // MARK: - Private methods
    
    private func indexForNote(id: ObjectIdentifier) -> Int {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return 0 }
        return index
    }
    
    private func sortListOfNote() {
        notes = notes.sorted { noteOne, noteTwo in
            guard let dateOne = noteOne.dateModified, let dateTwo = noteTwo.dateModified else { return false }
            return dateOne > dateTwo
        }
    }
    
    private func updateNote(at index: Int) {
        let note = notes[index]
        cellViewModels[index] = NoteViewCellViewModel(titleNote: note.title,
                                                      textNote: note.content,
                                                      dateCreated: note.dateCreated?.format(),
                                                      dateModified: note.dateModified?.format())
    }
    
    private func goToEditNote(_ note: Note?) {
        let viewModel = EditNoteViewModel(note: note)
        viewModel.delegate = self
        let viewController = EditNoteViewController(with: viewModel)
        didGoToNextScreen?(viewController)
    }
    
    private func getNotes() {
        NoteService.shared.fetchNotes { result in
            switch result {
            case .success(let downloadedNotes):
                notes = downloadedNotes
                DispatchQueue.main.async { [weak self] in
                    self?.didUpdateCollection?()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.showReceivedError?(error.errorDescription)
                }
            }
        }
    }
}

// MARK: - EditNoteViewModelDelegate

extension NotesScreenViewModel: EditNoteViewModelDelegate {
    func addNewNoteInCollection(note: Note) {
        notes.insert(note, at: 0)
        updateHeader()
        didUpdateCollection?()
    }
    
    func updateNoteInCollection(with id: ObjectIdentifier) {
        let index = indexForNote(id: id)
        updateNote(at: index)
        sortListOfNote()
        didUpdateCollection?()
    }
    
    func deleteNote(with id: ObjectIdentifier) {
        let index = indexForNote(id: id)
        notes.remove(at: index)
        updateHeader()
        didUpdateCollection?()
    }
    
    func showError(desc: String) {
        showReceivedError?(desc)
    }
}

