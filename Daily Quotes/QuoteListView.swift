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

    var body: some View {
        List {
            ForEach(dataManager.allQuotes.filter { $0.category == categoryKey }) { quote in
                VStack(alignment: .leading, spacing: 6) {
                    Text("“\(quote.text)”")
                        .font(.body)
                        .fontWeight(.medium)
                    Text("- \(quote.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(categoryName)
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
