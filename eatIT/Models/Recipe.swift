//
//  Recipe.swift
//  eatIT
//
//  Created by Denis Denisov on 10/4/24.
//

struct Recipes: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable {
    let title: String
    let image: String
    let summary: String
    let instructions: String
    let dishTypes: [String]
    let extendedIngredients: [Ingredient]
    
    let healthScore: Int
    let readyInMinutes: Int
}

struct Ingredient: Codable {
    let original: String
}
