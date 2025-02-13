//
//  CatalogInteractorInputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

protocol CatalogInteractorInputProtocol: AnyObject {
    func fetchItems(urlString: String) async
    func fetchImage(urlString: String) async -> UIImage?
}
