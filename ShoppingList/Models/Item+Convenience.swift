//
//  Item+Convenience.swift
//  ShoppingList
//
//  Created by Will morris on 5/10/19.
//  Copyright © 2019 devmtn. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    convenience init(name: String, isComplete: Bool = false, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        self.name = name
        self.isComplete = isComplete
    }
    
}
