import SwiftUI

/// Chat conversations list with listing context and unread badges.
struct ConversationsView: View {
    @Environment(AppRouter.self) private var router
    @State private var conversations = MockData.conversations
    @State private var searchText = ""

    private var filtered: [Conversation] {
        if searchText.isEmpty { return conversations }
        return conversations.filter {
            $0.otherUser.displayName.localizedCaseInsensitiveContains(searchText) ||
            ($0.listingTitle ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            ForEach(filtered) { conversation in
                Button {
                    router.navigate(to: .chatDetail(conversationID: conversation.id))
                } label: {
                    conversationRow(conversation)
                }
                .listRowBackground(VybeColors.background)
                .listRowSeparatorTint(VybeColors.border.opacity(0.3))
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search messages")
        .background(VybeColors.background)
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.large)
    }

    private func conversationRow(_ conv: Conversation) -> some View {
        HStack(spacing: VybeSpacing.sm) {
            // Avatar with online indicator
            ZStack(alignment: .bottomTrailing) {
                VybeAvatar(
                    name: conv.otherUser.displayName,
                    imageURL: conv.otherUser.avatarURL,
                    size: .medium
                )
                if conv.otherUser.isOnline {
                    Circle()
                        .fill(VybeColors.success)
                        .frame(width: 12, height: 12)
                        .overlay { Circle().stroke(VybeColors.background, lineWidth: 2) }
                }
            }

            VStack(alignment: .leading, spacing: VybeSpacing.xxxs) {
                // Name + Time
                HStack {
                    Text(conv.otherUser.displayName)
                        .font(VybeTypography.labelMedium)
                        .foregroundStyle(VybeColors.foreground)

                    Spacer()

                    if let time = conv.lastMessageAt {
                        Text(time.timeAgo)
                            .font(VybeTypography.caption)
                            .foregroundStyle(VybeColors.muted)
                    }
                }

                // Listing context
                if let title = conv.listingTitle {
                    HStack(spacing: VybeSpacing.xxs) {
                        Image(systemName: "tag.fill")
                            .font(.system(size: 9))
                        Text(title)
                            .lineLimit(1)
                    }
                    .font(VybeTypography.caption)
                    .foregroundStyle(VybeColors.accent)
                }

                // Last message + unread badge
                HStack {
                    Text(conv.lastMessage ?? "No messages yet")
                        .font(VybeTypography.bodySmall)
                        .foregroundStyle(conv.unreadCount > 0 ? VybeColors.foreground : VybeColors.muted)
                        .lineLimit(1)
                        .fontWeight(conv.unreadCount > 0 ? .medium : .regular)

                    Spacer()

                    if conv.unreadCount > 0 {
                        Text("\(conv.unreadCount)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(VybeColors.accentPink, in: Capsule())
                    }
                }
            }
        }
        .padding(.vertical, VybeSpacing.xxs)
    }
}

#Preview {
    NavigationStack {
        ConversationsView()
    }
    .environment(AppRouter())
}
