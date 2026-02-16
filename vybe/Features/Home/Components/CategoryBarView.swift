import SwiftUI

/// A horizontally scrollable row of category pills for filtering listings.
struct CategoryBarView: View {
    let selectedCategory: ListingCategory?
    let onSelect: (ListingCategory?) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: VybeSpacing.xs) {
                // "All" pill
                categoryPill(
                    title: "All",
                    icon: "square.grid.2x2",
                    isSelected: selectedCategory == nil
                ) {
                    onSelect(nil)
                }

                // Category pills
                ForEach(ListingCategory.allCases, id: \.self) { category in
                    categoryPill(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        onSelect(category)
                    }
                }
            }
            .padding(.horizontal, VybeSpacing.screenHorizontal)
        }
    }

    private func categoryPill(
        title: String,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: VybeSpacing.xxs) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(title)
                    .font(VybeTypography.labelMedium)
            }
            .padding(.horizontal, VybeSpacing.sm)
            .padding(.vertical, VybeSpacing.xs)
            .foregroundStyle(isSelected ? .white : VybeColors.muted)
            .background {
                if isSelected {
                    Capsule()
                        .fill(VybeColors.primaryGradient)
                } else {
                    Capsule()
                        .fill(VybeColors.surface)
                        .overlay {
                            Capsule()
                                .stroke(VybeColors.border, lineWidth: 1)
                        }
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
    }
}

#Preview {
    CategoryBarView(
        selectedCategory: .electronics,
        onSelect: { _ in }
    )
    .padding(.vertical)
    .background(VybeColors.background)
}
