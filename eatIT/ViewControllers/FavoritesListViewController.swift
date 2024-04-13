//
//  FavoritesListViewController.swift
//  eatIT
//
//  Created by Denis Denisov on 11/4/24.
//

import UIKit

final class FavoritesListViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    private var recipes: [CDRecipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = recipe.title
        
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [unowned self] _, _, _ in
            storageManager.delete(recipes[indexPath.row])
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}

private extension FavoritesListViewController {
    func fetchData() {
        storageManager.fetchData { [unowned self] response in
            switch response {
            case .success(let recipes):
                self.recipes = recipes
                tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
