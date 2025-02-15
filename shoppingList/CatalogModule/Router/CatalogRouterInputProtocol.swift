//
//  CatalogRouterInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

protocol CatalogRouterInputProtocol {
    func navigateToItemDetail(_ item: Item)
    func navigateToFilters(_ params: [String: String], _ delegate: FilterModuleDelegate)
}
