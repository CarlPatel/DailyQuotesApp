//
//  ContentView.swift
//  Daily Quotes
//
//  Created by Carl Patel on 7/30/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 1
    @State private var deepLinkedQuote: Quote? = nil
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                guard url.scheme == "dailyquotes" else { return }

                if url.host == "today" {
                    selectedTab = 1
                } else if url.host == "quote",
                          let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                          let idQueryItem = components.queryItems?.first(where: { $0.name == "id" }),
                          let id = idQueryItem.value,
                          let quote = dataManager.getQuote(by: id) {
                    navigationPath.append(quote)
                }
            }
            .navigationDestination(for: Quote.self) { quote in
                QuoteView(quote: quote)
            }
        }
    }
}
