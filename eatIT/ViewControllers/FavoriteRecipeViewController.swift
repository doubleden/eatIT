//
//  FavoriteRecipeViewController.swift
//  eatIT
//
//  Created by Denis Denisov on 13/4/24.
//

import UIKit
import Kingfisher

final class FavoriteRecipeViewController: UIViewController {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeLabel: UILabel!
    
    var recipe: CDRecipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImage.layer.cornerRadius = 25

        recipeImage.kf.setImage(with: URL(string: recipe.image ?? ""))
        recipeLabel.text = recipe.summary
    }

}
