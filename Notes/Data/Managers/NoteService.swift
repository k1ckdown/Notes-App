//
//  NoteService.swift
//  Notes
//
//  Created by Ivan Semenov on 12.02.2023.
//

import Foundation
import CoreData

final class NoteService {
    
    enum NoteServiceError: Error {
        case failedToCreate, failedToSave, failedFetchData, failedToDeleteData
        
        var errorDescription: String {
            switch self {
            case .failedToCreate:
                return "Failed to create new note"
            case .failedToSave:
                return "Failed to save note"
            case .failedFetchData:
                return "Failed fetch data"
            case .failedToDeleteData:
                return "Failed To delete note"
            }
        }
    }
    
    var context = CoreDataManager.shared.context
    
    static let shared = NoteService()
    
    private init() {}
    
    func createNote(title: String, content: String, dateCreated: Date, dateModified: Date, completion: (Result<Note, NoteServiceError>) -> Void) {
        let note = Note(context: context)
        note.title = title
        note.content = content
        note.dateCreated = dateCreated
        note.dateModified = dateModified
        
        do {
            try context.save()
            completion(.success(note))
        } catch {
            completion(.failure(NoteServiceError.failedToCreate))
        }
    }
    
    func updateNote(note: Note, title: String, content: String, dateModified: Date, completion: (Result<Note, NoteServiceError>) -> Void) {
        note.title = title
        note.content = content
        note.dateModified = dateModified
        
        do {
            try context.save()
            completion(.success(note))
        } catch {
            completion(.failure(NoteServiceError.failedToSave))
        }
    }
    
    func deleteNote(_ note: Note, completion: (Result<Void, NoteServiceError>) -> Void) {
        context.delete(note)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(NoteServiceError.failedToDeleteData))
        }
    }
    
    func fetchNotes(completion: (Result<[Note], NoteServiceError>) -> Void) {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.dateModified, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let notes = try context.fetch(request)
            completion(.success(notes))
        } catch {
            completion(.failure(NoteServiceError.failedFetchData))
        }
    }
}
