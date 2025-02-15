//
//  FilterViewInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

protocol FilterViewInputProtocol: AnyObject {
    func setupUI()
    func showInvalidPriceAlert(_ message: String)
}
