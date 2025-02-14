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
    
    private var isLoading = false
    private var nextPage = 0
    private var isPagination = false
    
    func viewDidLoad() {
        loadItems()
        view?.setupIndicator()
    }
    
    private func loadItems() {
        isLoading = true
        Task(priority: .userInitiated) {
            await interactor?.fetchItems(urlString: K.urlAPI + String(nextPage) + K.postfix)
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
        guard !isPagination && !items.isEmpty else {
            return
        }
        self.isLoading = false
        DispatchQueue.main.async {
            if self.isPagination {
                self.view?.appendItems(items)
                self.isPagination = false
            } else {
                self.view?.showItems(items)
            }
        }
    }
    
    func itemSelected(_ item: Item) {
        router?.navigateToItemDetail(item)
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
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
    
    func pagination() {
        guard !isLoading else { return }
        nextPage += 20
        isLoading = true
        isPagination = true
        Task(priority: .userInitiated) {
            await interactor?.fetchItems(urlString: K.urlAPI + String(nextPage) + K.postfix)
        }
    }
}
