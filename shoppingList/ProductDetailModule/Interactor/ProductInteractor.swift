//
//  ProductInteractor.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ProductInteractor: ProductInteractorInputProtocol {
    weak var output: ProductOutputProtocol?
    
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
