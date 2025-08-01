//
//  TodayView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//


import SwiftUI

struct TodayView: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        NavigationView {
            VStack {
                if let quote = dataManager.quoteOfTheDay {
                    QuoteView(quote: quote)
                } else {
                    Text("No quotes available for this category.")
                }
            }
            .navigationTitle("Quote of the Day")
            .toolbar {
                if let quote = dataManager.quoteOfTheDay {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(quote.categoryDisplayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(DataManager())
    }
}
