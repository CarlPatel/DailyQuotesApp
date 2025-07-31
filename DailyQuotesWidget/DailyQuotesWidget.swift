//
//  DailyQuotesWidget.swift
//  DailyQuotesWidget
//
//  Created by Carl Patel on 7/30/25.
//

import WidgetKit
import SwiftUI

struct QuoteProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: Quote(id: "placeholder", text: "Loading...", author: "", category: "simpsons"))
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        let entry = QuoteEntry(date: Date(), quote: loadQuoteOfTheDay())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let entry = QuoteEntry(date: Date(), quote: loadQuoteOfTheDay())

        let nextUpdate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date().addingTimeInterval(86400)

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    func loadQuoteOfTheDay() -> Quote {
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let quotes = try? JSONDecoder().decode([Quote].self, from: data) else {
            print("Failed to load quotes.json in widget.")
            return Quote(id: "fallback", text: "Stay curious.", author: "Widget", category: "default")
        }

        let selectedCategory = UserDefaults(suiteName: "group.com.DailyQuotes.shared")?.string(forKey: "selectedCategory") ?? "simpsons"
        print(selectedCategory)

        let quotesInCategory = quotes.filter { $0.category == selectedCategory }
        guard !quotesInCategory.isEmpty else {
            return Quote(id: "fallback", text: "No quotes available.", author: "", category: "")
        }

        let dayHash = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayHash % quotesInCategory.count
        return quotesInCategory[index]
    }
}

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

struct DailyQuotesWidgetEntryView: View {
    var entry: QuoteProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("“\(entry.quote.text)”")
                .font(.headline)
                .lineLimit(nil)
            Text("- \(entry.quote.author)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct DailyQuotesWidget: Widget {
    let kind: String = "DailyQuotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            DailyQuotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Quote")
        .description("Shows the quote of the day.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
