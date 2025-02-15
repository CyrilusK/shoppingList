//
//  FilterModuleDelegate.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

protocol FilterModuleDelegate: AnyObject {
    func didApplyFilters(_ filters: [String: String])
}
