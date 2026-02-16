import SwiftUI

/// Multi-step listing creation form with photo picker, category, pricing, and condition.
struct CreateListingView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var selectedCategory: ListingCategory = .other
    @State private var selectedCondition: ListingCondition = .good
    @State private var location = "San Francisco, CA"
    @State private var isNegotiable = true
    @State private var isSubmitting = false

    var body: some View {
        ScrollView {
            VStack(spacing: VybeSpacing.lg) {
                // Photo Section
                photoSection

                // Details
                VStack(alignment: .leading, spacing: VybeSpacing.md) {
                    sectionHeader("Details")

                    VybeTextField(
                        placeholder: "What are you selling?",
                        text: $title,
                        icon: "tag"
                    )

                    VStack(alignment: .leading, spacing: VybeSpacing.xxs) {
                        Text("Description")
                            .font(VybeTypography.labelSmall)
                            .foregroundStyle(VybeColors.muted)

                        TextEditor(text: $description)
                            .font(VybeTypography.bodyMedium)
                            .foregroundStyle(VybeColors.foreground)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 100)
                            .padding(VybeSpacing.sm)
                            .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)

                // Category & Condition
                VStack(alignment: .leading, spacing: VybeSpacing.md) {
                    sectionHeader("Category")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: VybeSpacing.xs) {
                            ForEach(ListingCategory.allCases, id: \.self) { category in
                                categoryPill(category)
                            }
                        }
                    }

                    sectionHeader("Condition")

                    HStack(spacing: VybeSpacing.xs) {
                        ForEach(ListingCondition.allCases, id: \.self) { condition in
                            conditionPill(condition)
                        }
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)

                // Pricing
                VStack(alignment: .leading, spacing: VybeSpacing.md) {
                    sectionHeader("Pricing")

                    HStack(spacing: VybeSpacing.xs) {
                        Text("$")
                            .font(VybeTypography.heading2)
                            .foregroundStyle(VybeColors.foreground)

                        TextField("0.00", text: $price)
                            .font(VybeTypography.heading2)
                            .foregroundStyle(VybeColors.foreground)
                            .keyboardType(.decimalPad)
                    }
                    .padding(VybeSpacing.sm)
                    .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))

                    Toggle(isOn: $isNegotiable) {
                        HStack(spacing: VybeSpacing.xs) {
                            Image(systemName: "hand.raised")
                                .foregroundStyle(VybeColors.accent)
                            Text("Open to offers")
                                .font(VybeTypography.bodyMedium)
                                .foregroundStyle(VybeColors.foreground)
                        }
                    }
                    .tint(VybeColors.accent)
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)

                // Location
                VStack(alignment: .leading, spacing: VybeSpacing.md) {
                    sectionHeader("Meetup Location")

                    HStack(spacing: VybeSpacing.sm) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(VybeColors.accent)

                        Text(location)
                            .font(VybeTypography.bodyMedium)
                            .foregroundStyle(VybeColors.foreground)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundStyle(VybeColors.muted)
                    }
                    .padding(VybeSpacing.sm)
                    .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)

                // Submit
                VybeButton(
                    title: "List Item",
                    icon: "checkmark.circle.fill",
                    variant: .primary,
                    size: .large,
                    isFullWidth: true,
                    isLoading: isSubmitting,
                    isDisabled: title.isEmpty || price.isEmpty
                ) {
                    Task { await submitListing() }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)
                .padding(.bottom, VybeSpacing.xxl)
            }
            .padding(.top, VybeSpacing.sm)
        }
        .background(VybeColors.background)
        .navigationTitle("New Listing")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") { dismiss() }
                    .foregroundStyle(VybeColors.muted)
            }
        }
    }

    // MARK: - Photo Section

    private var photoSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: VybeSpacing.sm) {
                // Add photo button
                Button {
                    // Photo picker
                } label: {
                    VStack(spacing: VybeSpacing.xs) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                        Text("Add Photos")
                            .font(VybeTypography.labelSmall)
                    }
                    .foregroundStyle(VybeColors.accent)
                    .frame(width: 100, height: 100)
                    .background(VybeColors.accent.opacity(0.08), in: RoundedRectangle(cornerRadius: VybeSpacing.radiusMD))
                    .overlay {
                        RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                            .stroke(VybeColors.accent.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [6]))
                    }
                }

                // Placeholder slots
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                        .fill(VybeColors.surfaceHover)
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(VybeColors.muted.opacity(0.3))
                        }
                }
            }
            .padding(.horizontal, VybeSpacing.screenHorizontal)
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(VybeTypography.heading4)
            .foregroundStyle(VybeColors.foreground)
    }

    private func categoryPill(_ category: ListingCategory) -> some View {
        Button {
            selectedCategory = category
        } label: {
            HStack(spacing: VybeSpacing.xxs) {
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                Text(category.rawValue)
                    .font(VybeTypography.labelSmall)
            }
            .padding(.horizontal, VybeSpacing.sm)
            .padding(.vertical, VybeSpacing.xxs)
            .foregroundStyle(selectedCategory == category ? .white : VybeColors.foreground)
            .background {
                if selectedCategory == category {
                    Capsule().fill(VybeColors.primaryGradient)
                } else {
                    Capsule().fill(VybeColors.surface)
                        .overlay { Capsule().stroke(VybeColors.border, lineWidth: 0.5) }
                }
            }
        }
    }

    private func conditionPill(_ condition: ListingCondition) -> some View {
        Button {
            selectedCondition = condition
        } label: {
            Text(condition.rawValue)
                .font(VybeTypography.labelSmall)
                .padding(.horizontal, VybeSpacing.sm)
                .padding(.vertical, VybeSpacing.xxs)
                .foregroundStyle(selectedCondition == condition ? .white : VybeColors.foreground)
                .background {
                    if selectedCondition == condition {
                        Capsule().fill(VybeColors.primaryGradient)
                    } else {
                        Capsule().fill(VybeColors.surface)
                            .overlay { Capsule().stroke(VybeColors.border, lineWidth: 0.5) }
                    }
                }
        }
    }

    private func submitListing() async {
        isSubmitting = true
        try? await Task.sleep(for: .seconds(1))
        isSubmitting = false
        dismiss()
    }
}

#Preview {
    NavigationStack {
        CreateListingView()
    }
}
