//
//  CategoryView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//

import SwiftUI
import WidgetKit

struct CategoryView: View {
    @Binding var selectedTab: Int
    let categories: [String: String] = [
        "simpsons": "The Simpsons",
        "one_tree_hill": "One Tree Hill",
        "gilmore_girls": "Gilmore Girls"
    ]

    // Persist selected category using AppStorage so it’s accessible app-wide
    @AppStorage("selectedCategory") private var selectedCategory: String = "simpsons"

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Select Your Quote Category")) {
                    ForEach(categories.sorted(by: { $0.value < $1.value }), id: \.key) { key, name in
                        HStack {
                            Text(name)
                            Spacer()
                            if selectedCategory == key {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle()) // Make whole row tappable
                        .onTapGesture {
                            selectedCategory = key
                            UserDefaults(suiteName: "group.com.DailyQuotes.shared")?.set(key, forKey: "selectedCategory")
                            print("Saved category to shared defaults: \(key)")

                            DispatchQueue.main.async {
                                    WidgetCenter.shared.reloadAllTimelines()
                                }

                            selectedTab = 1
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Category")
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(selectedTab: .constant(1))
    }
}
