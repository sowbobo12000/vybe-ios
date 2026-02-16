import Foundation

/// ViewModel for the home feed, managing featured listings, categories, and feed data.
@Observable
@MainActor
final class HomeViewModel {
    var featuredListings: [ListingSummary] = []
    var listings: [ListingSummary] = []
    var selectedCategory: ListingCategory? = nil
    var isLoading = false
    var isRefreshing = false
    var error: String?
    var hasMorePages = true
    private var currentPage = 1

    init() {
        Task { await loadInitialData() }
    }

    // MARK: - Data Loading

    func loadInitialData() async {
        isLoading = true
        error = nil

        // Simulate API delay
        try? await Task.sleep(for: .milliseconds(600))

        featuredListings = MockData.featuredListings
        listings = MockData.listings
        isLoading = false
    }

    func refresh() async {
        isRefreshing = true
        currentPage = 1
        hasMorePages = true

        try? await Task.sleep(for: .milliseconds(400))

        featuredListings = MockData.featuredListings
        listings = MockData.listings
        isRefreshing = false
    }

    func loadMore() async {
        guard hasMorePages, !isLoading else { return }
        currentPage += 1

        try? await Task.sleep(for: .milliseconds(300))

        // In production, fetch next page
        // For demo, signal no more pages
        hasMorePages = false
    }

    // MARK: - Filtering

    func selectCategory(_ category: ListingCategory?) {
        selectedCategory = category
        Task { await filterByCategory() }
    }

    private func filterByCategory() async {
        isLoading = true
        try? await Task.sleep(for: .milliseconds(300))

        if let category = selectedCategory {
            listings = MockData.listings.filter { $0.category == category.rawValue }
        } else {
            listings = MockData.listings
        }
        isLoading = false
    }

    // MARK: - Actions

    func toggleLike(for listingID: String) {
        if let index = listings.firstIndex(where: { $0.id == listingID }) {
            var listing = listings[index]
            listing.isLiked.toggle()
            listing.likeCount += listing.isLiked ? 1 : -1
            listings[index] = listing
        }
    }
}
