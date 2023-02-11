//
//  CreateNoteViewModel.swift
//  Notes
//
//  Created by Ivan Semenov on 10.02.2023.
//

import Foundation
import UIKit

final class CreateNoteViewModel {
    
    var didBeginEditingNote: (() -> Void)?
    var didEndEditingNote: (() -> Void)?
    
    private let note: Note?
    private var shouldShowSubTitle = false
    
    init(note: Note?) {
        self.note = note
    }
    
    func getTitle() -> String {
        guard let note = note else { return ""}
        return note.title
    }
    
    func getText() -> String {
        guard let note = note else { return "Your new note..."}
        return note.text
    }
    
    func getTextColor() -> UIColor {
        guard note != nil else { return .lightGray}
        return .white
    }
    
    func beginEditingOfNote() {
        didBeginEditingNote?()
    }
    
    func createNote(title: String?, text: String?) {
        didEndEditingNote?()
        guard let title = title, let text = text else { return }
        
        let note = CoreDataManager.shared.createNote()
        print(title)
        print(text)
    }
}
