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
        let cdRecipe = CDRecipe(context: context)
        cdRecipe.title = recipe.title
        cdRecipe.image = recipe.image
        cdRecipe.summary = recipe.summary
        cdRecipe.dishTypes = recipe.dishTypes as NSObject
        cdRecipe.instructions = recipe.instructions
        cdRecipe.readyInMinutes = Int64(recipe.readyInMinutes)
        cdRecipe.healthScore = Int64(recipe.healthScore)
        
        let ingredientsSet = recipe.extendedIngredients.map { ingredient -> CDIngredient in
            let cdIngredient = CDIngredient(context: context)
            cdIngredient.original = ingredient.original
            return cdIngredient
        }
        cdRecipe.extendedIngredients = NSSet(array: ingredientsSet)
        
        saveContext()
    }
    
    func delete(_ recipe: CDRecipe) {
        context.delete(recipe)
        saveContext()
    }
    
    func isRecipeInDataBase(_ recipe: Recipe) -> Bool {
        let fetchRequest = CDRecipe.fetchRequest()

        let predicate = NSPredicate(format: "title == %@", recipe.title)
        fetchRequest.predicate = predicate

        do {
            let cdRecipes = try context.fetch(fetchRequest)
            return cdRecipes.isEmpty
        } catch {
            print("Ошибка при выполнении запроса: \(error)")
            return false
        }
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
