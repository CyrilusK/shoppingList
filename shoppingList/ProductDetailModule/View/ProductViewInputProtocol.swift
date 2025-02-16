//
//  ProductViewInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

protocol ProductViewInputProtocol: AnyObject {
    func setupUI(_ item: Item)
    func updateUI(quantity: Int)
}
