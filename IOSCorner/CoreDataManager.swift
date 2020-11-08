//
//  CoreDataManager.swift
//  IOSCorner
//
//  Created by Andrey on 25.09.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let context = PersistingConteiner.shared.persistntContainer.viewContext
    
    func getOrders(completion: @escaping ([(Menu, Int )]) -> ()) {
        let fetch: NSFetchRequest<Order> = Order.fetchRequest()
        do {
            let result = try context.fetch(fetch)
            var menuItem = [(Menu, Int)]()
            
            for i in result {
                let menu = Menu(id: i.id?.uuidString ?? "", name: i.namePosition ?? "", description: i.descriptionOrder ?? "", price: Int(i.price), imageData: i.imageOrder)
                menuItem.append((menu, Int(i.count)))
            }
            completion(menuItem)
            
        } catch {
            print("Error")
        }
    }
    
    
    func saveOrder(item: Menu, count: Int) {
        guard let url = URL(string: item.image ?? "") else {
            return
        }
        NetworkManager.shared.downloadImage(url: url) { data in
            let order = Order(context: self.context)
            order.namePosition = item.name
            order.price = Int16(item.price)
            order.imageOrder = data
            order.count = Int16(count)
            do {
                try self.context.save()
            } catch {
                print("Error")
            }
        }
        
    }
    
    func removeOrder(item: Menu) {
        let fetch: NSFetchRequest<Order> = Order.fetchRequest()
        fetch.predicate = NSPredicate(format: "namePosition = '\(item.name)'")
        do {
            let result = try context.fetch(fetch)
            
            if result.isEmpty {
                fatalError("result is empty")
            }
            
            context.delete(result[0])
            try context.save()
        } catch {
            print("Error")
        }
    }
    
    func removeAll() {
        let fetch: NSFetchRequest<Order> = Order.fetchRequest()
        do {
            let result = try context.fetch(fetch)
            
            if result.isEmpty {
                fatalError("result is empty")
            }
            for i in result {
                context.delete(i)
            }
            
            try context.save()
        } catch {
            print("Error")
        }
    }
    
    func setNewCount(count: Int, menu: Menu) {
        let fetch: NSFetchRequest<Order> = Order.fetchRequest()
        fetch.predicate = NSPredicate(format: "namePosition = '\(menu.name)'")
        do {
            let result = try context.fetch(fetch)
            
            if result.isEmpty {
                fatalError("result is empty")
            }
            
            result[0].count = Int16(count)
            
            try context.save()
        } catch {
            print("Error")
        }
    }
    
}
