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
    
    private let item: Item

    init(item: Item) {
        self.item = item
    }

    func viewDidLoad() {
        view?.setupUI(item)
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
}
