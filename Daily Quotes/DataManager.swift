//
//  DataManager.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    @Published var allQuotes: [Quote] = []
    
    @AppStorage("favoriteQuoteIDs") private var favoriteQuoteIDsRaw: String = "[]"
    @AppStorage("selectedCategory") private var selectedCategory: String = ""

    var quoteOfTheDay: Quote? {
        let quotesInCategory = allQuotes.filter { $0.category == selectedCategory }
        guard !quotesInCategory.isEmpty else { return nil }

        let dayHash = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayHash % quotesInCategory.count
        return quotesInCategory[index]
    }

    var favoriteQuoteIDs: [String] {
        get {
            if let data = favoriteQuoteIDsRaw.data(using: .utf8),
               let decoded = try? JSONDecoder().decode([String].self, from: data) {
                return decoded
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                favoriteQuoteIDsRaw = string
            }
        }
    }

    var favoriteQuotes: [Quote] {
        allQuotes.filter { favoriteQuoteIDs.contains($0.id) }
    }

    func toggleFavorite(for quote: Quote) {
        if let index = favoriteQuoteIDs.firstIndex(of: quote.id) {
            favoriteQuoteIDs.remove(at: index)
        } else {
            favoriteQuoteIDs.append(quote.id)
        }
    }
    
    func getQuote(by id: String) -> Quote? {
        return allQuotes.first(where: { $0.id == id })
    }

    init() {
        loadQuotes()
    }

    private func loadQuotes() {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let quotes = try? JSONDecoder().decode([Quote].self, from: data)
        else {
            print("Failed to load quotes.json")
            return
        }

        self.allQuotes = quotes
    }
}
