//
//  CatalogViewInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

protocol CatalogViewInputProtocol: AnyObject {
    func setupIndicator()
    func setupUI()
    func showItems(_ items: [Item])
    func showError(_ message: String)
}
