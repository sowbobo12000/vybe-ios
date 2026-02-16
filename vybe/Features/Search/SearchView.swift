import SwiftUI

/// The search screen with text input, search history, filters, and results.
struct SearchView: View {
    var initialQuery: String? = nil

    @Environment(AppRouter.self) private var router
    @State private var viewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool

    private let columns = [
        GridItem(.flexible(), spacing: VybeSpacing.gridSpacing),
        GridItem(.flexible(), spacing: VybeSpacing.gridSpacing)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: VybeSpacing.lg) {
                // Search Bar
                searchBar

                if viewModel.hasSearched {
                    searchResults
                } else {
                    searchSuggestions
                }
            }
            .padding(.bottom, 100)
        }
        .background(VybeColors.background)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(VybeColors.background, for: .navigationBar)
        .sheet(isPresented: $viewModel.showFilters) {
            SearchFilterView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .task {
            if let initialQuery, !initialQuery.isEmpty {
                viewModel.query = initialQuery
                await viewModel.search()
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: VybeSpacing.xs) {
            HStack(spacing: VybeSpacing.xs) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(VybeColors.muted)

                TextField("Search marketplace...", text: $viewModel.query)
                    .font(VybeTypography.bodyMedium)
                    .foregroundStyle(VybeColors.foreground)
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        Task { await viewModel.search() }
                    }
                    .tint(VybeColors.accent)

                if !viewModel.query.isEmpty {
                    Button {
                        viewModel.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(VybeColors.muted)
                    }
                }
            }
            .padding(.horizontal, VybeSpacing.sm)
            .padding(.vertical, VybeSpacing.sm)
            .background(VybeColors.surface, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
            .overlay {
                RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                    .stroke(isSearchFocused ? VybeColors.accent.opacity(0.5) : VybeColors.border, lineWidth: 1)
            }

            // Filter button
            Button {
                viewModel.showFilters = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(VybeColors.foreground)
                    .padding(VybeSpacing.sm)
                    .background(VybeColors.surface, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
                    .overlay {
                        RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                            .stroke(VybeColors.border, lineWidth: 1)
                    }
            }
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
    }

    // MARK: - Search Results

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: VybeSpacing.md) {
            // Results header
            HStack {
                Text("\(viewModel.results.count) results")
                    .font(VybeTypography.labelMedium)
                    .foregroundStyle(VybeColors.muted)

                Spacer()

                Menu {
                    ForEach(SearchViewModel.SortOption.allCases, id: \.self) { option in
                        Button {
                            viewModel.sortOption = option
                            Task { await viewModel.search() }
                        } label: {
                            HStack {
                                Text(option.rawValue)
                                if viewModel.sortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: VybeSpacing.xxs) {
                        Text(viewModel.sortOption.rawValue)
                            .font(VybeTypography.labelSmall)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                    }
                    .foregroundStyle(VybeColors.accent)
                }
            }
            .padding(.horizontal, VybeSpacing.screenHorizontal)

            if viewModel.isLoading {
                LazyVGrid(columns: columns, spacing: VybeSpacing.gridSpacing) {
                    ForEach(0..<4, id: \.self) { _ in
                        ListingCardSkeleton()
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)
            } else if viewModel.results.isEmpty {
                noResults
            } else {
                LazyVGrid(columns: columns, spacing: VybeSpacing.gridSpacing) {
                    ForEach(viewModel.results) { listing in
                        Button {
                            router.navigate(to: .listingDetail(id: listing.id))
                        } label: {
                            ListingCardView(listing: listing)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)
            }
        }
    }

    // MARK: - No Results

    private var noResults: some View {
        VStack(spacing: VybeSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(VybeColors.muted)

            Text("No results for \"\(viewModel.query)\"")
                .font(VybeTypography.heading3)
                .foregroundStyle(VybeColors.foreground)

            Text("Try different keywords or adjust your filters")
                .font(VybeTypography.bodyMedium)
                .foregroundStyle(VybeColors.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, VybeSpacing.xxxl)
    }

    // MARK: - Search Suggestions

    private var searchSuggestions: some View {
        VStack(alignment: .leading, spacing: VybeSpacing.lg) {
            // Recent Searches
            if !viewModel.searchHistory.isEmpty {
                VStack(alignment: .leading, spacing: VybeSpacing.sm) {
                    HStack {
                        Text("Recent Searches")
                            .font(VybeTypography.heading4)
                            .foregroundStyle(VybeColors.foreground)
                        Spacer()
                        Button("Clear") { viewModel.clearHistory() }
                            .font(VybeTypography.labelSmall)
                            .foregroundStyle(VybeColors.muted)
                    }

                    ForEach(viewModel.searchHistory.prefix(5), id: \.self) { query in
                        Button {
                            viewModel.selectHistoryItem(query)
                        } label: {
                            HStack(spacing: VybeSpacing.sm) {
                                Image(systemName: "clock")
                                    .foregroundStyle(VybeColors.muted)
                                Text(query)
                                    .font(VybeTypography.bodyMedium)
                                    .foregroundStyle(VybeColors.foreground)
                                Spacer()
                                Image(systemName: "arrow.up.left")
                                    .font(.system(size: 12))
                                    .foregroundStyle(VybeColors.muted)
                            }
                            .padding(.vertical, VybeSpacing.xs)
                        }
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)
            }

            // Popular Categories
            VStack(alignment: .leading, spacing: VybeSpacing.sm) {
                Text("Browse Categories")
                    .font(VybeTypography.heading4)
                    .foregroundStyle(VybeColors.foreground)
                    .padding(.horizontal, VybeSpacing.screenHorizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: VybeSpacing.sm) {
                        ForEach(ListingCategory.allCases, id: \.self) { category in
                            Button {
                                viewModel.query = category.rawValue
                                Task { await viewModel.search() }
                            } label: {
                                VStack(spacing: VybeSpacing.xs) {
                                    Image(systemName: category.icon)
                                        .font(.system(size: 24))
                                        .foregroundStyle(VybeColors.accent)
                                        .frame(width: 56, height: 56)
                                        .background(VybeColors.accent.opacity(0.1), in: Circle())

                                    Text(category.rawValue)
                                        .font(VybeTypography.labelSmall)
                                        .foregroundStyle(VybeColors.foreground)
                                        .lineLimit(1)
                                }
                                .frame(width: 80)
                            }
                        }
                    }
                    .padding(.horizontal, VybeSpacing.screenHorizontal)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .environment(AppRouter())
}
