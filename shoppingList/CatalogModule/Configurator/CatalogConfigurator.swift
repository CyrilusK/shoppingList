//
//  CatalogConfigurator.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

final class CatalogConfigurator {
    func configure() -> UIViewController {
        let view = CatalogViewController()
        let presenter = CatalogPresenter()
        let interactor = CatalogInteractor()
        let router = CatalogRouter()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.entry = view
        
        return view
    }
}
