//
//  CatalogInteractor.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

final class CatalogInteractor: CatalogInteractorInputProtocol {
    weak var output: CatalogOutputProtocol?
    
    func fetchItems(urlString: String) async {
        do {
            let items = try await ApiManager().fetchItems(urlString: urlString)
            output?.didFetchItems(items)
        }
        catch {
            output?.showError(error)
        }
    }
    
    func fetchImage(urlString: String) async -> UIImage? {
        guard let imageURL = URL(string: urlString) else {
            return nil
        }
        do {
            let image = try await ImageLoader().loadImage(from: imageURL)
            return image
        }
        catch {
            return nil
        }
    }
}
