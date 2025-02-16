//
//  ProductRouter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ProductRouter: ProductRouterInputProtocol {
    weak var entry: UIViewController?
    
    func navigateToShoppingList() {
        let shopVC = ShoppingListConfigurator().configure()
        entry?.navigationController?.pushViewController(shopVC, animated: true)
    }
}
