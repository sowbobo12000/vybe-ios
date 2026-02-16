import SwiftUI

/// A bottom sheet filter view for refining search results.
struct SearchFilterView: View {
    @Bindable var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var priceMinText = ""
    @State private var priceMaxText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: VybeSpacing.xl) {
                    // Category Filter
                    filterSection(title: "Category") {
                        FlowLayout(spacing: VybeSpacing.xs) {
                            ForEach(ListingCategory.allCases, id: \.self) { category in
                                filterChip(
                                    title: category.rawValue,
                                    isSelected: viewModel.selectedCategory == category
                                ) {
                                    viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                                }
                            }
                        }
                    }

                    // Condition Filter
                    filterSection(title: "Condition") {
                        FlowLayout(spacing: VybeSpacing.xs) {
                            ForEach(ListingCondition.allCases, id: \.self) { condition in
                                filterChip(
                                    title: condition.rawValue,
                                    isSelected: viewModel.selectedCondition == condition
                                ) {
                                    viewModel.selectedCondition = viewModel.selectedCondition == condition ? nil : condition
                                }
                            }
                        }
                    }

                    // Price Range
                    filterSection(title: "Price Range") {
                        HStack(spacing: VybeSpacing.sm) {
                            VybeTextField(
                                placeholder: "Min",
                                text: $priceMinText,
                                icon: "dollarsign",
                                keyboardType: .numberPad
                            )
                            Text("to")
                                .font(VybeTypography.bodyMedium)
                                .foregroundStyle(VybeColors.muted)
                            VybeTextField(
                                placeholder: "Max",
                                text: $priceMaxText,
                                icon: "dollarsign",
                                keyboardType: .numberPad
                            )
                        }
                    }

                    // Sort By
                    filterSection(title: "Sort By") {
                        VStack(spacing: VybeSpacing.xs) {
                            ForEach(SearchViewModel.SortOption.allCases, id: \.self) { option in
                                Button {
                                    viewModel.sortOption = option
                                } label: {
                                    HStack {
                                        Text(option.rawValue)
                                            .font(VybeTypography.bodyMedium)
                                            .foregroundStyle(VybeColors.foreground)
                                        Spacer()
                                        if viewModel.sortOption == option {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(VybeColors.accent)
                                        } else {
                                            Circle()
                                                .stroke(VybeColors.border, lineWidth: 1.5)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    .padding(.vertical, VybeSpacing.xs)
                                }
                            }
                        }
                    }
                }
                .padding(VybeSpacing.screenHorizontal)
            }
            .background(VybeColors.background)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(VybeColors.background, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        viewModel.resetFilters()
                        priceMinText = ""
                        priceMaxText = ""
                    }
                    .foregroundStyle(VybeColors.muted)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        viewModel.priceMin = Int(priceMinText).map { $0 * 100 }
                        viewModel.priceMax = Int(priceMaxText).map { $0 * 100 }
                        Task { await viewModel.search() }
                        dismiss()
                    }
                    .font(VybeTypography.labelMedium)
                    .foregroundStyle(VybeColors.accent)
                }
            }
        }
    }

    // MARK: - Components

    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: VybeSpacing.sm) {
            Text(title)
                .font(VybeTypography.heading4)
                .foregroundStyle(VybeColors.foreground)
            content()
        }
    }

    private func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(VybeTypography.labelMedium)
                .padding(.horizontal, VybeSpacing.sm)
                .padding(.vertical, VybeSpacing.xs)
                .foregroundStyle(isSelected ? .white : VybeColors.foreground)
                .background {
                    if isSelected {
                        Capsule().fill(VybeColors.primaryGradient)
                    } else {
                        Capsule()
                            .fill(VybeColors.surface)
                            .overlay { Capsule().stroke(VybeColors.border, lineWidth: 1) }
                    }
                }
        }
    }
}

/// A simple flow layout for wrapping filter chips.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func computeLayout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var maxHeight: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += maxHeight + spacing
                maxHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            maxHeight = max(maxHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + maxHeight), positions)
    }
}
