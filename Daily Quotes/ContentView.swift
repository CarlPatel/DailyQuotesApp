//
//  ContentView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            CategoryView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Category", systemImage: "square.grid.2x2")
                }
                .tag(0)

            TodayView()
                .tabItem {
                    Label("Today", systemImage: "quote.bubble")
                }
                .tag(1)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(2)
        }
        .onOpenURL { url in
            if url.host == "today" {
                selectedTab = 1
            }
        }
    }
}
