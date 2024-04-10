//
//  Recipe.swift
//  eatIT
//
//  Created by Denis Denisov on 10/4/24.
//

struct Recipe {
    let title: String
    let image: String
    let summary: String
    let instructions: String
    let dishTypes: [String]
    let extendedIngredients: [Ingredient]
    
    let healthScore: Int
    let readyInMinute: Int
}

struct Ingredient {
    let original: String
}
