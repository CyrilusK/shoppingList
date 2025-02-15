//
//  FilterRouter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

final class FilterRouter: FilterRouterInputProtocol {
    weak var entry: UIViewController?
    
    func dismiss() {
        entry?.dismiss(animated: true)
    }
}
