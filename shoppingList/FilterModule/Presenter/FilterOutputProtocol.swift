//
//  FilterOutputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

protocol FilterOutputProtocol: AnyObject {
    var selectedCategory: Categories? { get }
    func viewDidLoad()
    func toggleCategory(_ category: Categories)
    func applyFilters(title: String?, minPrice: String?, maxPrice: String?, price: String?)
    func cleanFilters()
    func getParams() -> [String: String]
}
