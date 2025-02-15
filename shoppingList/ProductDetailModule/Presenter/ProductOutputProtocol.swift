//
//  ProductOutputProtocol.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

protocol ProductOutputProtocol: AnyObject {
    func viewDidLoad()
    func getImage(_ url: String?, completion: @escaping (UIImage?) -> Void)
}
