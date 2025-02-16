//
//  ProductInteractorInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

protocol ProductInteractorInputProtocol: AnyObject {
    func fetchImage(urlString: String) async -> UIImage?
    func checkItemInList(by id: Int) -> Int
    func addItemToList(item: Item)
    func updateItemQuantity(itemID: Int, quantity: Int)
}
