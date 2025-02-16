//
//  ShoppingListInteractor.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ShoppingListInteractor: ShoppingListInteractorInputProtocol {
    weak var output: ShoppingListOutputProtocol?
    private let storageManager = CoreDataManager.shared
    
    func fetchImage(urlString: String) async -> UIImage? {
        guard let imageURL = URL(string: urlString) else {
            return nil
        }
        do {
            let image = try await ImageLoader().loadImage(from: imageURL)
            return image
        }
        catch {
            return nil
        }
    }
    
    func fetchShoppingItems() {
        let items = storageManager.fetchItems()
        output?.didLoadItems(items)
    }
    
    func updateItemQuantity(item: ShoppingItemEntity, quantity: Int) {
        storageManager.updateQuantity(Int(item.id), newQuantity: quantity)
    }
    
    func deleteItem(item: ShoppingItemEntity) {
        storageManager.deleteItem(item)
    }
    
    func clearAllItems() {
        storageManager.clearShoppingList()
    }
}
