import Foundation

/// ViewModel for the search screen, managing query, filters, and results.
@Observable
@MainActor
final class SearchViewModel {
    var query = ""
    var results: [ListingSummary] = []
    var searchHistory: [String] = []
    var isLoading = false
    var hasSearched = false
    var selectedCategory: ListingCategory? = nil
    var selectedCondition: ListingCondition? = nil
    var priceMin: Int? = nil
    var priceMax: Int? = nil
    var sortOption: SortOption = .newest
    var showFilters = false

    enum SortOption: String, CaseIterable {
        case newest = "Newest"
        case priceAsc = "Price: Low to High"
        case priceDesc = "Price: High to Low"
        case distance = "Distance"
        case popular = "Most Popular"
    }

    init() {
        searchHistory = UserDefaultsManager.searchHistory
    }

    // MARK: - Search

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        isLoading = true
        hasSearched = true

        UserDefaultsManager.addSearchQuery(trimmed)
        searchHistory = UserDefaultsManager.searchHistory

        // Simulate API search
        try? await Task.sleep(for: .milliseconds(500))

        var filtered = MockData.listings.filter { listing in
            listing.title.localizedCaseInsensitiveContains(trimmed) ||
            listing.itemDescription.localizedCaseInsensitiveContains(trimmed) ||
            listing.category.localizedCaseInsensitiveContains(trimmed)
        }

        // Apply filters
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category.rawValue }
        }
        if let condition = selectedCondition {
            filtered = filtered.filter { $0.condition == condition.rawValue }
        }
        if let min = priceMin {
            filtered = filtered.filter { $0.price >= min }
        }
        if let max = priceMax {
            filtered = filtered.filter { $0.price <= max }
        }

        // Apply sort
        switch sortOption {
        case .newest:
            filtered.sort { $0.createdAt > $1.createdAt }
        case .priceAsc:
            filtered.sort { $0.price < $1.price }
        case .priceDesc:
            filtered.sort { $0.price > $1.price }
        case .distance:
            break // Would sort by distance from user
        case .popular:
            filtered.sort { $0.likeCount > $1.likeCount }
        }

        results = filtered
        isLoading = false
    }

    func clearSearch() {
        query = ""
        results = []
        hasSearched = false
    }

    func clearHistory() {
        UserDefaultsManager.clearSearchHistory()
        searchHistory = []
    }

    func selectHistoryItem(_ item: String) {
        query = item
        Task { await search() }
    }

    func resetFilters() {
        selectedCategory = nil
        selectedCondition = nil
        priceMin = nil
        priceMax = nil
        sortOption = .newest
    }
}
