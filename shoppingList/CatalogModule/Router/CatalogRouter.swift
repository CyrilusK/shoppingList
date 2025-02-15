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
        let productVC = ProductDetailConfigurator().configure(item: item)
        entry?.navigationController?.pushViewController(productVC, animated: true)
    }
    
    func navigateToFilters(_ params: [String: String], _ delegate: FilterModuleDelegate) {
        let filterVC = FilterConfigurator().configure(params: params, delegate: delegate)
        
        if let sheet = filterVC.sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .large
            }
        }
        entry?.present(filterVC, animated: true)
    }
}
