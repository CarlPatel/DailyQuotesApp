//
//  QuoteListView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/31/25.
//

import SwiftUI
import WidgetKit

struct QuoteListView: View {
    let categoryKey: String
    let categoryName: String
    @EnvironmentObject var dataManager: DataManager
    @AppStorage("selectedCategory") private var selectedCategory: String = "simpsons"
    @State private var searchText: String = ""

    var filteredQuotes: [Quote] {
        dataManager.allQuotes.filter { quote in
            quote.category == categoryKey &&
            (searchText.isEmpty ||
             quote.text.localizedCaseInsensitiveContains(searchText) ||
             quote.author.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        ZStack {
            List {
                ForEach(filteredQuotes) { quote in
                    NavigationLink(destination: QuoteView(quote: quote)) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("“\(quote.text)”")
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("- \(quote.author)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        let isFavorited = dataManager.favoriteQuoteIDs.contains(quote.id)
                        Button {
                            dataManager.toggleFavorite(for: quote)
                        } label: {
                            Label(isFavorited ? "Unfavorite" : "Favorite", systemImage: isFavorited ? "heart.slash" : "heart")
                        }
                        .tint(isFavorited ? .gray : .red)
                    }
                }
            }

            // ✨ Empty state overlay
            if filteredQuotes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)

                    if searchText.isEmpty {
                        Text("No quotes available.")
                            .foregroundColor(.secondary)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 4) {
                            Text("No quotes found for:")
                                .foregroundColor(.secondary)
                                .font(.title3)
                                .multilineTextAlignment(.center)

                            Text("“\(searchText)”")
                                .foregroundColor(.secondary)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(categoryName)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .automatic),
            prompt: "Search quote or author"
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    selectedCategory = categoryKey
                    UserDefaults(suiteName: "group.com.DailyQuotes.shared")?.set(categoryKey, forKey: "selectedCategory")
                    print("Saved category to shared defaults: \(categoryKey)")

                    DispatchQueue.main.async {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }) {
                    Image(systemName: selectedCategory == categoryKey ? "star.fill" : "star")
                        .foregroundColor(.blue)
                        .accessibilityLabel("Mark \(categoryName) as selected category")
                }
            }
        }
    }
}
