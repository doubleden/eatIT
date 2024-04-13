//
//  StorageManager.swift
//  eatIT
//
//  Created by Denis Denisov on 12/4/24.
//

import CoreData

final class StorageManager {
     static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "eatIT")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    func fetchData(_ completion: @escaping(Result<[CDRecipe], Error>) -> Void) {
        let fetchRequest = CDRecipe.fetchRequest()
        
        do {
            let cdRecipes = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                completion(.success(cdRecipes))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(_ recipe: Recipe) {
        
        recipe.toCDRecipe(context: context)
        saveContext()
    }
    
    func delete(_ recipe: CDRecipe) {
        context.delete(recipe)
        saveContext()
    }
    
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

extension Recipe {
    func toCDRecipe(context: NSManagedObjectContext) {
        let cdRecipe = CDRecipe(context: context)
        cdRecipe.title = self.title
        cdRecipe.image = self.image
        cdRecipe.summary = self.summary
        cdRecipe.instructions = self.instructions
        cdRecipe.dishTypes = self.dishTypes as NSObject
        cdRecipe.healthScore = Int64(self.healthScore)
        cdRecipe.readyInMinutes = Int64(self.readyInMinutes)
        
        let cdIngredients = self.extendedIngredients.map { $0.toCDIngredient(context: context) }
        cdRecipe.extendedIngredients = NSSet(array: cdIngredients)
    }
}

extension Ingredient {
    func toCDIngredient(context: NSManagedObjectContext) -> CDIngredient {
        let cdIngredient = CDIngredient(context: context)
        cdIngredient.original = self.original
        return cdIngredient
    }
}
