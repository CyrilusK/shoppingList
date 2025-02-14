//
//  CatalogOutputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

protocol CatalogOutputProtocol: AnyObject {
    func viewDidLoad()
    func reloadItems()
    func itemSelected(_ item: Item)
    func showError(_ error: Error)
    func getImage(_ url: String?, completion: @escaping (UIImage?) -> Void)
    func didFetchItems(_ items: [Item])
    func pagination()
    func didSearchTextChange(_ text: String)
    func getSearchHistory() -> [String]
}
