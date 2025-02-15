//
//  ProductDetailConfigurator.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

final class ProductDetailConfigurator {
    func configure(item: Item) -> UIViewController {
        let view = ProductDetailViewController()
        let presenter = ProductDetailPresenter(item: item)
        let interactor = ProductInteractor()

        view.output = presenter
        presenter.view = view
        interactor.output = presenter
        presenter.interactor = interactor
        
        return view
    }
}
