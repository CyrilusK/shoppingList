//
//  FilterConfigurator.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

final class FilterConfigurator {
    func configure(params: [String: String], delegate: FilterModuleDelegate) -> UIViewController {
        let view = FilterViewController()
        let presenter = FilterPresenter(parameters: params)
        let router = FilterRouter()
        
        view.output = presenter
        presenter.view = view
        presenter.delegate = delegate
        presenter.router = router
        router.entry = view
        
        return view
    }
}
