//
//  PersistingConteiner.swift
//  IOSCorner
//
//  Created by Andrey on 25.09.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class PersistingConteiner {
    static let shared = PersistingConteiner()
    
    lazy var persistntContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IOSCorner")
        
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Error PersistentContainer userInfo \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistntContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Error at saving context \(error.userInfo)")
            }
        }
    }
}
