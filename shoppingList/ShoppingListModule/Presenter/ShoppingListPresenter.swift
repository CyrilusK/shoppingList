//
//  ShoppingListPresenter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ShoppingListPresenter: ShoppingListOutputProtocol {
    weak var view: ShoppingListViewInputProtocol?
    var interactor: ShoppingListInteractorInputProtocol?
    var router: ShoppingListRouterInputProtocol?
    
    private var items: [ShoppingItemEntity] = []
    
    func viewDidLoad() {
        interactor?.fetchShoppingItems()
        //NotificationCenter.default.addObserver(self, selector: #selector(handleShoppingListUpdate), name: .shoppingListUpdated, object: nil)
    }
    
    func didLoadItems(_ items: [ShoppingItemEntity]) {
        self.items = items
        view?.setupUI()
    }
    
    func deleteItem(at index: Int) {
        interactor?.deleteItem(item: items[index])
        items.remove(at: index)
        view?.reloadData()
    }
    
    func clearList() {
        interactor?.clearAllItems()
        items.removeAll()
        view?.reloadData()
    }
    
    func shareList() {
        let text = items.map { "\($0.title ?? "") - \($0.quantity) шт. - \($0.price * Double($0.quantity)) $" }.joined(separator: "\n")
        view?.shareText(text)
    }
    
    func getItems() -> [ShoppingItemEntity] {
        items
    }
    
    func didSelectItem(at index: Int) {
        let entity = items[index]
        let item = Item(id: Int(entity.id),
                        title: entity.title ?? "",
                        price: entity.price,
                        description: entity.desc ?? "",
                        category: Category(id: Int(entity.id), name: "", image: ""),
                        images: [entity.image ?? ""])
        
        router?.navigateToItemDetail(item)
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
    
    func increaseQuantity(at index: Int) {
        let item = items[index]
        let newQuantity = Int(item.quantity) + 1
        interactor?.updateItemQuantity(item: item, quantity: newQuantity)
    }

    func decreaseQuantity(at index: Int) {
        let item = items[index]
        let newQuantity = max(1, Int(item.quantity) - 1)
        interactor?.updateItemQuantity(item: item, quantity: newQuantity)
    }
}
