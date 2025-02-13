//
//  CatalogRouter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

final class CatalogRouter: CatalogRouterInputProtocol {
    weak var entry: UIViewController?
    
    func navigateToItemDetail(_ item: Item) {
        entry?.present(ViewController(), animated: true)
    }
}
