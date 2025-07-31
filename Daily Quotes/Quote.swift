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
        switch category {
        case "simpsons": return "The Simpsons"
        case "one_tree_hill": return "One Tree Hill"
        case "gilmore_girls": return "Gilmore Girls"
        default: return category.capitalized
        }
    }
}
