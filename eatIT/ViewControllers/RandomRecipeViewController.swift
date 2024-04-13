//
//  ViewController.swift
//  eatIT
//
//  Created by Denis Denisov on 10/4/24.
//

import UIKit
import Kingfisher

final class RandomRecipeViewController: UIViewController {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var summaryLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    private var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeImage.layer.cornerRadius = 20
        fetchData()
    }

    @IBAction func updateButtonAction() {
        fetchData()
    }
    
    
    @IBAction func saveRecipeAction() {
        storageManager.save(recipe)
    }
}

private extension RandomRecipeViewController {
    func fetchData() {
        
        Task {
            do {
                recipe = try await networkManager.fetchRecipe(
                    from: API.randomRecipe.url,
                    with: API.randomRecipe.headers
                ).recipes
                    .first
                navigationItem.title = recipe.title
                summaryLabel.text = removeHTMLTags(from: recipe.summary)
                recipeImage.kf.setImage(with: URL(string: recipe.image))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeHTMLTags(from string: String) -> String {
        let pattern = "<[^>]+>"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: string.utf16.count)
        let htmlLessString = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
        return htmlLessString
    }
}
