import SwiftUI

/// Community groups directory with join/leave and listing counts.
struct CommunitiesView: View {
    var highlightedCommunityID: String? = nil

    @Environment(AppRouter.self) private var router
    @State private var communities = MockData.communities
    @State private var searchText = ""
    @State private var selectedFilter: Filter = .all

    enum Filter: String, CaseIterable {
        case all = "All"
        case joined = "Joined"
        case featured = "Featured"
    }

    private var filtered: [Community] {
        var result = communities
        switch selectedFilter {
        case .joined: result = result.filter(\.isJoined)
        case .featured: result = result.filter(\.isFeatured)
        case .all: break
        }
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }

    var body: some View {
        ScrollView {
            VStack(spacing: VybeSpacing.lg) {
                // Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: VybeSpacing.xs) {
                        ForEach(Filter.allCases, id: \.self) { filter in
                            filterPill(filter)
                        }
                    }
                    .padding(.horizontal, VybeSpacing.screenHorizontal)
                }

                // Community Cards
                LazyVStack(spacing: VybeSpacing.md) {
                    ForEach(filtered) { community in
                        communityCard(community)
                            .scrollReveal()
                    }
                }
                .padding(.horizontal, VybeSpacing.screenHorizontal)
            }
            .padding(.top, VybeSpacing.sm)
            .padding(.bottom, 100)
        }
        .searchable(text: $searchText, prompt: "Search communities")
        .background(VybeColors.background)
        .navigationTitle("Communities")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Filter Pill

    private func filterPill(_ filter: Filter) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) { selectedFilter = filter }
        } label: {
            Text(filter.rawValue)
                .font(VybeTypography.labelSmall)
                .foregroundStyle(selectedFilter == filter ? .white : VybeColors.foreground)
                .padding(.horizontal, VybeSpacing.md)
                .padding(.vertical, VybeSpacing.xs)
                .background {
                    if selectedFilter == filter {
                        Capsule().fill(VybeColors.primaryGradient)
                    } else {
                        Capsule().fill(VybeColors.surface)
                            .overlay { Capsule().stroke(VybeColors.border, lineWidth: 0.5) }
                    }
                }
        }
    }

    // MARK: - Community Card

    private func communityCard(_ community: Community) -> some View {
        VybeCard {
            VStack(alignment: .leading, spacing: VybeSpacing.sm) {
                HStack(spacing: VybeSpacing.sm) {
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: VybeSpacing.radiusMD)
                            .fill(VybeColors.accent.opacity(0.12))
                            .frame(width: 48, height: 48)
                        Text(String(community.name.prefix(1)))
                            .font(VybeTypography.heading2)
                            .foregroundStyle(VybeColors.accent)
                    }

                    VStack(alignment: .leading, spacing: VybeSpacing.xxxs) {
                        HStack(spacing: VybeSpacing.xxs) {
                            Text(community.name)
                                .font(VybeTypography.heading4)
                                .foregroundStyle(VybeColors.foreground)
                            if community.isFeatured {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12))
                                    .foregroundStyle(VybeColors.warning)
                            }
                        }

                        HStack(spacing: VybeSpacing.sm) {
                            Label("\(Formatters.formatCount(community.memberCount))", systemImage: "person.2")
                            Label("\(Formatters.formatCount(community.listingCount))", systemImage: "tag")
                        }
                        .font(VybeTypography.caption)
                        .foregroundStyle(VybeColors.muted)
                    }

                    Spacer()

                    // Join Button
                    Button {
                        toggleJoin(community)
                    } label: {
                        Text(community.isJoined ? "Joined" : "Join")
                            .font(VybeTypography.labelSmall)
                            .foregroundStyle(community.isJoined ? VybeColors.muted : .white)
                            .padding(.horizontal, VybeSpacing.md)
                            .padding(.vertical, VybeSpacing.xxs)
                            .background {
                                if community.isJoined {
                                    Capsule().stroke(VybeColors.border, lineWidth: 1)
                                } else {
                                    Capsule().fill(VybeColors.primaryGradient)
                                }
                            }
                    }
                }

                Text(community.description)
                    .font(VybeTypography.bodySmall)
                    .foregroundStyle(VybeColors.muted)
                    .lineLimit(2)

                // Category badge
                VybeBadge(text: community.category)
            }
        }
    }

    private func toggleJoin(_ community: Community) {
        if let index = communities.firstIndex(where: { $0.id == community.id }) {
            withAnimation(.spring(response: 0.3)) {
                communities[index].isJoined.toggle()
                communities[index].memberCount += communities[index].isJoined ? 1 : -1
            }
        }
    }
}

#Preview {
    NavigationStack {
        CommunitiesView()
    }
    .environment(AppRouter())
}
