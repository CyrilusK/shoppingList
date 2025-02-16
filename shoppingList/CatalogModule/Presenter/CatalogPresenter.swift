//
//  CatalogPresenter.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

final class CatalogPresenter: CatalogOutputProtocol, FilterModuleDelegate {
    weak var view: CatalogViewInputProtocol?
    var interactor: CatalogInteractorInputProtocol?
    var router: CatalogRouterInputProtocol?
    
    private var isLoading = false
    private var nextPage = 0
    private var isPagination = false
    
    private var items: [Item] = []
    private var filteredItems: [Item] = []
    private var isSearchActive: Bool = false
    private var selectedFilters: [String: String] = [:]
    private var searchHistory: [String] = [] {
        didSet {
            UserDefaults.standard.set(searchHistory, forKey: K.searchHistory)
            view?.updateSearchHistory(searchHistory)
        }
    }
    
    init() {
        searchHistory = UserDefaults.standard.stringArray(forKey: K.searchHistory) ?? []
    }
    
    func viewDidLoad() {
        loadItems()
        view?.setupIndicator()
    }
    
    private func loadItems() {
        isLoading = true
        Task(priority: .userInitiated) {
            await interactor?.fetchItems(urlString: buildFilteredURL())
            DispatchQueue.main.async {
                self.view?.setupUI()
            }
        }
    }
    
    func reloadItems() {
        Task(priority: .userInitiated) {
            await interactor?.fetchItems(urlString: buildFilteredURL())
        }
    }
    
    func didFetchItems(_ items: [Item]) {
        isLoading = false
        if isPagination {
            DispatchQueue.main.async {
                self.items.append(contentsOf: items)
                self.view?.appendItems(items)
            }
            isPagination = false
        } else {
            DispatchQueue.main.async {
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
            completion(image)
        }
    }
    
    func pagination() {
        guard !isLoading else { return }
        nextPage += 20
        isLoading = true
        isPagination = true
        reloadItems()
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
        updateView()
    }
    
    private func updateView() {
        let itemsForDisplay = isSearchActive ? filteredItems : items
        view?.showItems(itemsForDisplay)
    }
    
    func getSearchHistory() -> [String] {
        return searchHistory
    }
    
    func openFilterScreen() {
        router?.navigateToFilters(selectedFilters, self)
    }
    
    private func buildFilteredURL() -> String {
        var url = K.urlAPI
        
        if !selectedFilters.isEmpty {
            let queryParams = selectedFilters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            url += "?" + queryParams
        }
        url += (selectedFilters.isEmpty ? "?" : "&") + K.offset + String(nextPage) + K.limit
        return url
    }
    
    func didApplyFilters(_ filters: [String: String]) {
        selectedFilters = filters
        nextPage = 0
        reloadItems()
        print("[DEBUG] Примененные фильтры: \(buildFilteredURL())")
    }
}
