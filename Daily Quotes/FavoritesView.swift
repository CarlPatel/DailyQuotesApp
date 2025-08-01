//
//  FavoritesView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//


import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var displayedFavorites: [Quote] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(displayedFavorites) { quote in
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
                }
            }
            .navigationTitle("Favorite Quotes")
            .onAppear {
                    displayedFavorites = dataManager.favoriteQuotes
                }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let previewManager = DataManager()
        previewManager.allQuotes = [
            Quote(id: "simpsons-1", text: "Just because I don’t care doesn’t mean I don’t understand.", author: "Homer Simpson", category: "simpsons")
        ]
        previewManager.toggleFavorite(for: previewManager.allQuotes[0])
        return FavoritesView()
            .environmentObject(previewManager)
    }
}
