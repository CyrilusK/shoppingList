//
//  Constants.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

struct K {
    //Для обработки ошибок
    static let invalidURL = "Invalid URL"
    static let noData = "No data received"
    static let decodingError = "Failed to decode data:"
    static let networkError = "Network error:"
    static let serverError = "Failed to download image from server"
    
    //Ключ api
    static let urlAPI = "https://api.escuelajs.co/api/v1/products?offset="
    static let postfix = "&limit=20"
    
    //Идентификатор
    static let reuseIdentifier = "ItemCell"
}
