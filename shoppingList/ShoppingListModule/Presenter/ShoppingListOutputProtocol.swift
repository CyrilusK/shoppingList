//
//  ShoppingListOutputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

protocol ShoppingListOutputProtocol: AnyObject {
    func viewDidLoad()
    func didLoadItems(_ items: [ShoppingItemEntity])
    func deleteItem(at index: Int)
    func clearList()
    func shareList()
    func getItems() -> [ShoppingItemEntity]
    func didSelectItem(at index: Int)
    func getImage(_ url: String?, completion: @escaping (UIImage?) -> Void)
    func increaseQuantity(at index: Int)
    func decreaseQuantity(at index: Int)
}
