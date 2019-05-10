//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Will morris on 5/10/19.
//  Copyright © 2019 devmtn. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title
        title = "Shopping List"
        
        // Set delegate for ItemController
        ItemController.shared.fetchedResultsController.delegate = self
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        // Call alert function
        promptAddItem()
    }
    
    // MARK: - Table view data source
    
    func promptAddItem() {
        
        // Create alert controller
        let alertController = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        alertController.addTextField()
        
        // Create text field with button and have it add item using text from text field
        let submitAction = UIAlertAction(title: "Add", style: .default) { [unowned alertController] _ in
            
            let answer = alertController.textFields?[0]
            guard let text = answer?.text else { return }
            
            if text == "" {
                return
            } else {
                ItemController.shared.add(item: text)
            }
        }
        
        // Add the action to the alert controller, a cancel button, and present it on the view
        alertController.addAction(submitAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    // Set the row height to 50
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Set number of rows equal to how many objects are fetched from persistance store
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    // Creates the cell content using the ButtonTableViewCell and sets the cells delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        
        let item = ItemController.shared.fetchedResultsController.object(at: indexPath)
        cell.update(item: item)
        cell.delegate = self

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ItemController.shared.fetchedResultsController.object(at: indexPath)
            ItemController.shared.delete(item: item)
        }
    }

}

// MARK: - Delegates

// ButtonTableViewCellDelegate Functions
extension ShoppingListTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else { return }
        let item = ItemController.shared.fetchedResultsController.object(at: index)
        ItemController.shared.toggleIsComplete(item: item)
        sender.update(item: item)
    }
    
}

// Fetched results delegate to get fetched data from ItemController
extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            fatalError()
        }
    }
    
}

