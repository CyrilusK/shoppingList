//
//  Categories.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

enum Categories: Int, CaseIterable {
    case clothing = 1
    case electronics
    case furniture
    case shoes
    case miscellaneous
    case laptops
    case accessories

    var name: String {
        switch self {
        case .clothing: return "Одежда"
        case .electronics: return "Электроника"
        case .furniture: return "Мебель"
        case .shoes: return "Обувь"
        case .miscellaneous: return "Разное"
        case .laptops: return "Ноутбуки"
        case .accessories: return "Аксессуары"
        }
    }
}
