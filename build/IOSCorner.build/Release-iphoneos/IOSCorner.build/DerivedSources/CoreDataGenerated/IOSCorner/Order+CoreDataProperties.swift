//
//  Order+CoreDataProperties.swift
//  
//
//  Created by Andrey on 15.11.2020.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var bayerName: String?
    @NSManaged public var count: Int16
    @NSManaged public var descriptionOrder: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imageOrder: Data?
    @NSManaged public var namePosition: String?
    @NSManaged public var price: Int16

}
