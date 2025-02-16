//
//  ShoppingItemEntity+CoreDataProperties.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//
//

import Foundation
import CoreData


@objc(ShoppingItemEntity)
public class ShoppingItemEntity: NSManagedObject {}

extension ShoppingItemEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItemEntity> {
        return NSFetchRequest<ShoppingItemEntity>(entityName: K.shoppingItemEntity)
    }
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var category: Int64
    @NSManaged public var image: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var desc: String?
}

extension ShoppingItemEntity : Identifiable {
}
