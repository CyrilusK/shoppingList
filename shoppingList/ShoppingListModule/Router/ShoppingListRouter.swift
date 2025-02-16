//
//  ShoppingListRouter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ShoppingListRouter: ShoppingListRouterInputProtocol {
    weak var entry: UIViewController?
    
    func navigateToItemDetail(_ item: Item) {
        let productVC = ProductDetailConfigurator().configure(item: item)
        entry?.navigationController?.pushViewController(productVC, animated: true)
    }
}
