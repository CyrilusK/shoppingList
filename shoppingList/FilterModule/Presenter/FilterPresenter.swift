//
//  FilterPresenter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

final class FilterPresenter: FilterOutputProtocol {
    weak var view: FilterViewInputProtocol?
    var router: FilterRouterInputProtocol?
    
    weak var delegate: FilterModuleDelegate?
    
    private var parameters: [String: String]
    var selectedCategory: Categories?
    
    init(parameters: [String : String]) {
        self.parameters = parameters
    }
    
    func viewDidLoad() {
        view?.setupUI()
    }
    
    func toggleCategory(_ category: Categories) {
        if selectedCategory == category {
                selectedCategory = nil
        } else {
            selectedCategory = category
        }
    }
    
    func applyFilters(title: String?, minPrice: String?, maxPrice: String?, price: String?) {
        var filters: [String: String] = [:]
        if let minPriceStr = minPrice, let maxPriceStr = maxPrice,
           let minPriceValue = Double(minPriceStr), let maxPriceValue = Double(maxPriceStr) {
            print(minPriceValue, maxPriceValue)
            if minPriceValue > maxPriceValue {
                view?.showInvalidPriceAlert("Мин. цена не может быть больше макс.")
                return
            }
        }

        if let title = title, !title.isEmpty {
            filters[K.title] = title
        }
        if let minPrice = minPrice, !minPrice.isEmpty {
            filters[K.priceMin] = minPrice
        }
        if let maxPrice = maxPrice, !maxPrice.isEmpty {
            filters[K.priceMin] = maxPrice
        }
        if let price = price, !price.isEmpty {
            filters[K.price] = price
        }
        if let category = selectedCategory {
            filters[K.categoryId] = String(category.rawValue)
        }

        delegate?.didApplyFilters(filters)
        router?.dismiss()
    }
    
    func cleanFilters() {
        selectedCategory = nil
        applyFilters(title: nil, minPrice: nil, maxPrice: nil, price: nil)
    }
    
    func getParams() -> [String: String] {
        parameters
    }
}
