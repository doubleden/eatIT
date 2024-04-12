//
//  NetworkManager.swift
//  eatIT
//
//  Created by Denis Denisov on 12/4/24.
//

import Foundation
import Alamofire

enum API {
    case randomRecipe
    
    var url: URL {
        switch self {
        case .randomRecipe:
            URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random")!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .randomRecipe:
            ["X-RapidAPI-Key": "f413c3987dmsh3d1a526eb1a693ap17a44djsn83f1b31f4ff7",
             "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"]
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchRecipe(from url: URL, with headers: HTTPHeaders) async throws -> Data {
        let request = AF.request(url, headers: headers).validate()
        
        do {
            let data = try await request.serializingDecodable(Data.self).value
            return data
        } catch {
            throw error
        }
    }
}
