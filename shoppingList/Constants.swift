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
    static let urlAPI = "https://api.escuelajs.co/api/v1/products/"
    static let offset = "offset="
    static let limit = "&limit=20"
    
    //Идентификатор
    static let reuseIdentifier = "ItemCell"
    static let historyCell = "HistoryCell"
    static let searchHistory = "searchHistory"
    static let categoryCell = "CategoryCell"
    static let shoppingItemCell = "ShoppingItemCell"
    
    static let shoppingItemEntity = "ShoppingItemEntity"
    
    static let textPlaceholderSearchBar = "Поиск товаров"
    static let notFound = "Не найдено"
    static let errorLoading = "Ошибка загрузки данных \nПопробуйте еще раз"
    static let photo = "photo"
    
    static let title = "title"
    static let priceMin = "price_min"
    static let priceMax = "price_max"
    static let price = "price"
    static let categoryId = "categoryId"
    
    static let shareButtonImage = "square.and.arrow.up"
    static let filterButton = "line.horizontal.3.decrease.circle"
    static let trashFill = "trash.fill"
}

extension Notification.Name {
    static let shoppingListUpdated = Notification.Name("shoppingListUpdated")
}
