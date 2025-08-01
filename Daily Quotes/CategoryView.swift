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

    @AppStorage("selectedCategory") private var selectedCategory: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(Quote.categories.sorted(by: { $0.value < $1.value }), id: \.key) { key, name in
                    NavigationLink(destination: QuoteListView(categoryKey: key, categoryName: name)) {
                        HStack {
                            Text(name)
                            Spacer()
                            if selectedCategory == key {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.blue)
                            }
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
