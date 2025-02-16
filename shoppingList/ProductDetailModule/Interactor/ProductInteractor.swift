//
//  ProductInteractor.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ProductInteractor: ProductInteractorInputProtocol {
    weak var output: ProductOutputProtocol?
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
    
    func checkItemInList(by id: Int) -> Int {
        storageManager.getItemQuantity(id)
    }
    
    func addItemToList(item: Item) {
        storageManager.addItem(item)
    }
    
    func updateItemQuantity(itemID: Int, quantity: Int) {
        storageManager.updateQuantity(itemID, newQuantity: quantity)
    }
}
