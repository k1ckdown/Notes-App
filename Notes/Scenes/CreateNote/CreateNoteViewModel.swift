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
    
    weak var delegate: NotesScreenDelegate?
    
    private let note: Note?
    private var shouldShowSubTitle = false
    
    init(note: Note?) {
        self.note = note
    }
    
    func getTitle() -> String {
        guard let title = note?.title else { return "" }
        return title
    }
    
    func getText() -> String {
        guard let content = note?.content else { return "Your new note..."}
        return content
    }
    
    func getTextColor() -> UIColor {
        guard note?.content != nil else { return .lightGray}
        return .white
    }
    
    func beginEditingOfNote() {
        didBeginEditingNote?()
    }
    
    func createNote(title: String?, text: String?) {
        didEndEditingNote?()
        guard let title = title, let text = text else { return }
        
        note?.title = title
        note?.content = text
        note?.dateCreated = Date().format()
        note?.dateModified = Date().format()
        
        delegate?.refreshNote(at: note?.id)
    }
}
