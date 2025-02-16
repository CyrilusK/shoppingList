//
//  CoreDataManager.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol {
    func addItem(_ item: Item)
    func fetchItems() -> [ShoppingItemEntity]
    func updateQuantity(_ itemIF: Int, newQuantity: Int)
    func deleteItem(_ item: ShoppingItemEntity)
    func clearShoppingList()
}

// MARK: - CRUD
final class CoreDataManager: CoreDataManagerProtocol {
    public static let shared = CoreDataManager()
    
    private var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate?.persistentContainer.viewContext ?? NSManagedObjectContext()
    }
    
    func addItem(_ item: Item) {
        let shoppingItem = ShoppingItemEntity(context: context)
        shoppingItem.id = Int64(item.id)
        shoppingItem.title = item.title
        shoppingItem.desc = item.description
        shoppingItem.price = item.price
        shoppingItem.category = Int64(item.category.id)
        shoppingItem.image = item.images.first
        shoppingItem.quantity = 1
        appDelegate?.saveContext()
    }
    
    func fetchItems() -> [ShoppingItemEntity] {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("[DEBUG] Ошибка загрузки данных: \(error)")
            return []
        }
    }
    
    func updateQuantity(_ itemID: Int, newQuantity: Int) {
        let fetchRequest: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", itemID)
        
        do {
            let items = try context.fetch(fetchRequest)
            if let existingItem = items.first {
                existingItem.quantity = Int64(newQuantity)
                appDelegate?.saveContext()
            }
        } catch {
            print("Ошибка при обновлении количества товара: \(error)")
        }
    }

    
    func deleteItem(_ item: ShoppingItemEntity) {
        context.delete(item)
        appDelegate?.saveContext()
    }
    
    func clearShoppingList() {
        let request: NSFetchRequest<NSFetchRequestResult> = ShoppingItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            appDelegate?.saveContext()
        } catch {
            print("[DEBUG] Ошибка очистки: \(error)")
        }
    }
    
    func getItemQuantity(_ itemID: Int) -> Int {
        let fetchRequest: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", itemID)
        
        do {
            let items = try CoreDataManager.shared.context.fetch(fetchRequest)
            return Int(items.first?.quantity ?? 0)
        } catch {
            print("[DEBUG] Ошибка при получении количества товара: \(error)")
            return 0
        }
    }
}
