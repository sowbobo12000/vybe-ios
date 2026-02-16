import SwiftUI

/// Real-time chat screen with message bubbles and listing context header.
struct ChatDetailView: View {
    let conversationID: String

    @Environment(AppRouter.self) private var router
    @State private var messages: [Message] = []
    @State private var conversation: Conversation?
    @State private var inputText = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Listing Context Banner
            if let conv = conversation, let title = conv.listingTitle {
                listingBanner(title: title, price: conv.listingPrice)
            }

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: VybeSpacing.xs) {
                        ForEach(messages) { message in
                            messageBubble(message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, VybeSpacing.screenHorizontal)
                    .padding(.vertical, VybeSpacing.sm)
                }
                .onChange(of: messages.count) { _, _ in
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            // Input Bar
            inputBar
        }
        .background(VybeColors.background)
        .navigationTitle(conversation?.otherUser.displayName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadData() }
    }

    // MARK: - Listing Banner

    private func listingBanner(title: String, price: Int?) -> some View {
        HStack(spacing: VybeSpacing.sm) {
            Image(systemName: "tag.fill")
                .font(.system(size: 12))
                .foregroundStyle(VybeColors.accent)

            Text(title)
                .font(VybeTypography.labelSmall)
                .foregroundStyle(VybeColors.foreground)
                .lineLimit(1)

            Spacer()

            if let price {
                Text(Formatters.formatPrice(price))
                    .font(VybeTypography.labelMedium)
                    .foregroundStyle(VybeColors.accent)
            }
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
        .padding(.vertical, VybeSpacing.xs)
        .background(VybeColors.surface)
        .overlay(alignment: .bottom) {
            Rectangle().fill(VybeColors.border.opacity(0.3)).frame(height: 0.5)
        }
    }

    // MARK: - Message Bubble

    private func messageBubble(_ message: Message) -> some View {
        HStack {
            if message.isMine { Spacer(minLength: 60) }

            VStack(alignment: message.isMine ? .trailing : .leading, spacing: VybeSpacing.xxxs) {
                // Offer badge
                if message.type == .offer, let amount = message.offerAmount {
                    HStack(spacing: VybeSpacing.xxs) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 11))
                        Text("Offer: \(Formatters.formatPrice(amount))")
                            .font(VybeTypography.labelSmall)
                    }
                    .padding(.horizontal, VybeSpacing.sm)
                    .padding(.vertical, VybeSpacing.xxs)
                    .background(VybeColors.accent.opacity(0.15), in: Capsule())
                    .foregroundStyle(VybeColors.accent)
                }

                // Bubble
                Text(message.content)
                    .font(VybeTypography.bodyMedium)
                    .foregroundStyle(message.isMine ? .white : VybeColors.foreground)
                    .padding(.horizontal, VybeSpacing.sm)
                    .padding(.vertical, VybeSpacing.xs)
                    .background(
                        message.isMine ? AnyShapeStyle(VybeColors.primaryGradient) : AnyShapeStyle(VybeColors.surface),
                        in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                    )
                    .overlay {
                        if !message.isMine {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(VybeColors.border.opacity(0.3), lineWidth: 0.5)
                        }
                    }

                // Timestamp
                Text(message.createdAt.timeAgo)
                    .font(.system(size: 10))
                    .foregroundStyle(VybeColors.muted)
            }

            if !message.isMine { Spacer(minLength: 60) }
        }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: VybeSpacing.xs) {
            TextField("Message...", text: $inputText, axis: .vertical)
                .font(VybeTypography.bodyMedium)
                .foregroundStyle(VybeColors.foreground)
                .lineLimit(1...4)
                .padding(.horizontal, VybeSpacing.sm)
                .padding(.vertical, VybeSpacing.xs)
                .background(VybeColors.surfaceHover, in: RoundedRectangle(cornerRadius: 20))
                .focused($isInputFocused)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(inputText.isEmpty ? VybeColors.muted : VybeColors.accent)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, VybeSpacing.screenHorizontal)
        .padding(.vertical, VybeSpacing.xs)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay { Rectangle().fill(VybeColors.surface.opacity(0.7)) }
                .overlay(alignment: .top) {
                    Rectangle().fill(VybeColors.border.opacity(0.3)).frame(height: 0.5)
                }
                .ignoresSafeArea()
        }
    }

    // MARK: - Actions

    private func loadData() {
        conversation = MockData.conversations.first { $0.id == conversationID }
        messages = MockData.messages.filter { $0.conversationID == conversationID }
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        let msg = Message(
            id: UUID().uuidString,
            conversationID: conversationID,
            senderID: "current-user-id",
            senderName: "Alex Johnson",
            content: text,
            isRead: true,
            createdAt: Date()
        )
        messages.append(msg)
        inputText = ""
    }
}

#Preview {
    NavigationStack {
        ChatDetailView(conversationID: "conv-1")
    }
    .environment(AppRouter())
}
