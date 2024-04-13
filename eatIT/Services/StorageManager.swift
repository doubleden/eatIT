//
//  StorageManager.swift
//  eatIT
//
//  Created by Denis Denisov on 12/4/24.
//

import CoreData

final class StorageManager {
     static let shared = StorageManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "eatIT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    private func saveContext () {
        let context = persistentContainer.viewContext
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
