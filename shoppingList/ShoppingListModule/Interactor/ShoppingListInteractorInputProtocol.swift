//
//  ShoppingListInteractorInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit


protocol ShoppingListInteractorInputProtocol: AnyObject {
    func fetchImage(urlString: String) async -> UIImage?
    func fetchShoppingItems()
    func updateItemQuantity(item: ShoppingItemEntity, quantity: Int)
    func deleteItem(item: ShoppingItemEntity)
    func clearAllItems()
}
