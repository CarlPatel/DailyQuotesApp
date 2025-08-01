//
//  QuoteView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//

import SwiftUI

struct QuoteView: View {
    let quote: Quote
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack(spacing: 24) {
            
        

            Text("“\(quote.text)”")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal)
                .lineLimit(nil)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: 600)

            Text("- \(quote.author)")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal)
                .frame(maxWidth: 500)
            

            
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
            .padding(.top, 24)
            
        
            
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: "“\(quote.text)”\n– \(quote.author)") {
                    Image(systemName: "square.and.arrow.up")
                        .accessibilityLabel("Share Text")
                }
            }
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(
            quote: Quote(id: "wild-1", text: "When life comes rushing at you out of the darkness, who will you choose to face it with? Will it be someone you trust? Will they be wise? And will their love for you help them to guide you to the light, or will they lose their way in the darkness? Will they make noble choices? Or will that person be untested, someone new? Life comes rushing at you from out of the darkness. When it does, is there someone in your life you can count on—someone who will watch over you when you stumble and fall, and in that moment,give you the strengthto face your fears alone?", author: "Oscar Wilde", category: "inspiration")
        )
        .environmentObject(DataManager())
    }
}
