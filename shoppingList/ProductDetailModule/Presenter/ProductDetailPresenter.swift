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
    private var currentQuantity: Int = 1
    private var isInList: Bool = false

    init(item: Item) {
        self.item = item
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func viewDidLoad() {
        view?.setupUI(item)
        getItemQuantity()
        NotificationCenter.default.addObserver(self, selector: #selector(handleShoppingListUpdate), name: .shoppingListUpdated, object: nil)
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
        if quantity == 0 {
            currentQuantity = 1
            isInList = false
        } else {
            currentQuantity = quantity
            isInList = true
        }
        view?.updateUI(quantity: currentQuantity, isInList: isInList)
    }
    
    func updateQuantity(_ newQuantity: Int) {
        currentQuantity = newQuantity
        interactor?.updateItemQuantity(itemID: item.id, quantity: currentQuantity)
        view?.updateUI(quantity: currentQuantity, isInList: isInList)
    }
    
    func handleAddToListTapped() {
        if isInList {
            interactor?.updateItemQuantity(itemID: item.id, quantity: currentQuantity)
            router?.navigateToShoppingList()
        } else {
            interactor?.addItemToList(item: item)
            isInList = true
            view?.updateUI(quantity: currentQuantity, isInList: isInList)
        }
    }
    
    @objc private func handleShoppingListUpdate() {
        print(#function)
        getItemQuantity()
    }
}


