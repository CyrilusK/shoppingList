//
//  ShoppingListConfigurator.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ShoppingListConfigurator {
    func configure() -> UIViewController {
        let view = ShoppingListViewController()
        let presenter = ShoppingListPresenter()
        let interactor = ShoppingListInteractor()
        let router = ShoppingListRouter()

        view.output = presenter
        presenter.view = view
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.router = router
        router.entry = view
        
        return view
    }
}
