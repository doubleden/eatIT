//
//  Extension + Recipe + Ingredient.swift
//  eatIT
//
//  Created by Denis Denisov on 13/4/24.
// Extension for conversion Recipes to CDRecipes
import CoreData

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
