//
//  Item.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    let image: String
}

struct Item: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    var images: [String]
}
