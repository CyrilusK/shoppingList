//
//  CatalogPresenter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

final class CatalogPresenter: CatalogOutputProtocol {
    weak var view: CatalogViewInputProtocol?
    var interactor: CatalogInteractorInputProtocol?
    var router: CatalogRouterInputProtocol?
    
    func viewDidLoad() {
        loadItems()
        view?.setupIndicator()
    }
    
    private func loadItems() {
        Task(priority: .userInitiated) {
            await interactor?.fetchItems(urlString: K.urlAPI)
            DispatchQueue.main.async {
                self.view?.setupUI()
            }
        }
    }
    
    func reloadItems() {
        Task(priority: .userInitiated) {
            await interactor?.fetchItems(urlString: K.urlAPI)
        }
    }
    
    func didFetchItems(_ items: [Item]) {
        DispatchQueue.main.async {
            self.view?.showItems(items)
        }
    }
    
    func itemSelected(_ item: Item) {
        router?.navigateToItemDetail(item)
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            if let error = error as? ApiError {
                self.view?.showError("Failed to load news: \(error.errorDescription)")
            } else {
                self.view?.showError("Failed to load news: \(error.localizedDescription)")
            }
        }
    }
    
    func getImage(_ url: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(UIImage(systemName: "photo"))
            return
        }
        
        Task(priority: .userInitiated) {
            let image = await interactor?.fetchImage(urlString: url)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
