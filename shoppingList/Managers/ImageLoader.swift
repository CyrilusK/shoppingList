//
//  ImageLoader.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

final class ImageLoader {
    func loadImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}
