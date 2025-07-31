//
//  QuoteView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//

import SwiftUI

struct QuoteView: View {
    let quote: Quote
    @Binding var isFavorited: Bool
    var showToolbar: Bool = false
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack(spacing: 24) {

            Text("“\(quote.text)”")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                dataManager.toggleFavorite(for: quote)
            }) {
                Label(
                    dataManager.favoriteQuoteIDs.contains(quote.id) ? "Saved" : "Save to Favorites",
                    systemImage: dataManager.favoriteQuoteIDs.contains(quote.id) ? "heart.fill" : "heart"
                )
                .foregroundColor(dataManager.favoriteQuoteIDs.contains(quote.id) ? .red : .blue)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(
            quote: Quote(id: "wild-1", text: "Be yourself; everyone else is already taken.", author: "Oscar Wilde", category: "inspiration"),
            isFavorited: .constant(false)
        )
        .environmentObject(DataManager())
    }
}
