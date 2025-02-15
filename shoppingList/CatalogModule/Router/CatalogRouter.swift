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
        entry?.present(FilterViewController(), animated: true)
    }
    
    func navigateToFilters(_ params: [String: String]) {
        let filterVC = FilterViewController()
        
        if let sheet = filterVC.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .large
            }
        }
        entry?.present(filterVC, animated: true)
    }
}
