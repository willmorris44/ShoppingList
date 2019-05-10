//
//  ItemController.swift
//  ShoppingList
//
//  Created by Will morris on 5/10/19.
//  Copyright © 2019 devmtn. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    static var shared = ItemController()
    
    var moc = CoreDataStack.context
    
    let fetchedResultsController: NSFetchedResultsController<Item>
    
    init() {
        // Create fetch request and set a sort descriptor
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true)]
        
        // Create a fetched results controller using request and moc
        let fetchedResults: NSFetchedResultsController<Item> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = fetchedResults
        
        // Perform the fetch for data
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing fetch: \(error) : \(error.localizedDescription)")
        }
    }
    
    //CRUD
    func add(item name: String) {
        let _ = Item(name: name)
        saveToPersistanceStore()
    }
    
    func delete(item: Item) {
        moc.delete(item)
        saveToPersistanceStore()
    }
    
    func toggleIsComplete(item: Item) {
        item.isComplete = !item.isComplete
        saveToPersistanceStore()
    }
    
    //Persistance
    func saveToPersistanceStore() {
        
        do {
            try moc.save()
        } catch {
            print("There was an error saving to the persistance store: \(error) : \(error.localizedDescription)")
        }
    }
    
}
