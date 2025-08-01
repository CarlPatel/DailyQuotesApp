//
//  FavoritesView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText: String = ""
    
    var filteredFavorites: [Quote] {
        dataManager.favoriteQuotes.filter { quote in
            searchText.isEmpty ||
            quote.text.localizedCaseInsensitiveContains(searchText) ||
            quote.author.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(filteredFavorites) { quote in
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
                            Button(role: .destructive) {
                                dataManager.toggleFavorite(for: quote)
                            } label: {
                                Label("Unfavorite", systemImage: "heart.slash")
                            }
                            .tint(.gray)
                        }
                    }
                }
                
                if filteredFavorites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)

                        if searchText.isEmpty {
                            Text("No favorite quotes yet.")
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
            .navigationTitle("Favorite Quotes")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search quote or author")
        }
    }
}
