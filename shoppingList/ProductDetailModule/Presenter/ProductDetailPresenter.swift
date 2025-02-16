//
//  ProductDetailPresenter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

final class ProductDetailPresenter: ProductOutputProtocol {
    weak var view: ProductViewInputProtocol?
    var interactor: ProductInteractorInputProtocol?
    var router: ProductRouterInputProtocol?
    
    private let item: Item
    private var currentQuantity: Int = 0

    init(item: Item) {
        self.item = item
    }

    func viewDidLoad() {
        view?.setupUI(item)
        getItemQuantity()
    }
    
    func getImage(_ url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(UIImage(systemName: K.photo))
            return
        }
        
        Task(priority: .userInitiated) {
            let image = await interactor?.fetchImage(urlString: url)
            completion(image)
        }
    }
    
    func navigateToShoppingList() {
        router?.navigateToShoppingList()
    }
    
    func getItemQuantity() {
        let quantity = interactor?.checkItemInList(by: item.id) ?? 0
        currentQuantity = quantity
        view?.updateUI(quantity: currentQuantity)
    }
    
    func updateQuantity(_ newQuantity: Int) {
        interactor?.updateItemQuantity(itemID: item.id, quantity: currentQuantity)
        currentQuantity = newQuantity
        view?.updateUI(quantity: currentQuantity)
    }
    
    func handleAddToListTapped() {
        if currentQuantity > 0 {
            router?.navigateToShoppingList()
        } else {
            interactor?.addItemToList(item: item)
            currentQuantity = 1
            view?.updateUI(quantity: currentQuantity)
        }
    }
}


