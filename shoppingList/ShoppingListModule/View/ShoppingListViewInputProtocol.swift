//
//  ShoppingListViewInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

protocol ShoppingListViewInputProtocol: AnyObject {
    func setupUI()
    func reloadData()
    func shareText(_ text: String)
}

protocol ShoppingItemCellDelegate: AnyObject {
    func didTapIncreaseQuantity(in cell: ShoppingItemCell)
    func didTapDecreaseQuantity(in cell: ShoppingItemCell)
}
