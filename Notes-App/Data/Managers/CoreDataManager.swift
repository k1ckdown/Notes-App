//
//  CoreDataManager.swift
//  Notes-App
//
//  Created by Ivan Semenov on 11.02.2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "Notes")
    
    private let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func loadStore(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Core Data store failed to load: \(error)")
            }
        }
    }
}
