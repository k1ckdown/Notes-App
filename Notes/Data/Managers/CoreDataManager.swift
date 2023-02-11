//
//  CoreDataManager.swift
//  Notes
//
//  Created by Ivan Semenov on 11.02.2023.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager(modelName: "Notes")

    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func load() {
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// MARK: - Helper functions

extension CoreDataManager {
    func createNote() -> Note {
        let note = Note(context: context)
        
        note.title = ""
        note.content = ""
        note.dateCreated = Date()
        note.dateModified = Date()

        saveContext()
        return note
    }

    func fetchNotes(completion: (Result<[Note], Error>) -> Void){
        let request: NSFetchRequest<Note> = Note.fetchRequest()

        do {
            let notes = try context.fetch(request)
            completion(.success(notes))
        } catch {
            completion(.failure(error))
        }
    }

    func deleteNote(_ note: Note) {
        context.delete(note)
        saveContext()
    }
}
