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
    
    private var items: [Item] = []
    private var filteredItems: [Item] = []
    private var isSearchActive: Bool = false
    private var searchHistory: [String] = [] {
        didSet {
            UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
        }
    }
    
    init() {
        searchHistory = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    }
    
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
        guard !items.isEmpty else {
            return
        }
        self.isLoading = false
        DispatchQueue.main.async {
            if self.isPagination {
                self.items.append(contentsOf: items)
                self.view?.appendItems(items)
                self.isPagination = false
            } else {
                self.items = items
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
            completion(UIImage(systemName: K.photo))
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
    
    func didSearchTextChange(_ text: String) {
        isSearchActive = !text.isEmpty
        
        if isSearchActive {
            if let index = searchHistory.firstIndex(of: text) {
                searchHistory.remove(at: index)
            }
            searchHistory.insert(text, at: 0)
            if searchHistory.count > 5 {
                searchHistory.removeLast()
            }
        }
        
        filteredItems = isSearchActive ? items.filter { $0.title.lowercased().contains(text.lowercased()) } : []
        view?.updateSearchHistory(searchHistory)
        updateView()
    }
    
    private func updateView() {
        let itemsForDisplay = isSearchActive ? filteredItems : items
        view?.showItems(itemsForDisplay)
    }
    
    func getSearchHistory() -> [String] {
        return searchHistory
    }
}
