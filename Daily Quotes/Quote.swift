//
//  Quote.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//

import Foundation

struct Quote: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let text: String
    let author: String
    let category: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var categoryDisplayName: String {
        Quote.categories[category] ?? category.capitalized
    }

    static let categories: [String: String] = [
        "simpsons": "The Simpsons",
        "one_tree_hill": "One Tree Hill",
        "gilmore_girls": "Gilmore Girls"
    ]
}
