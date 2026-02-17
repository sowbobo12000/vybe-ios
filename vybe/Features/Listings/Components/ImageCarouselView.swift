import SwiftUI

/// A fullscreen-width image carousel with page indicators and zoom support.
/// Uses ScrollView with paging instead of TabView to avoid blocking vertical scroll.
struct ImageCarouselView: View {
    let imageURLs: [String]
    @State private var currentIndex = 0
    @State private var showFullScreen = false

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                let pageWidth = proxy.size.width

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(Array(imageURLs.enumerated()), id: \.offset) { index, urlString in
                            AsyncImage(url: URL(string: urlString)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: pageWidth, height: 340)
                                        .clipped()
                                        .contentShape(Rectangle())
                                        .onTapGesture { showFullScreen = true }
                                case .failure:
                                    placeholder
                                        .frame(width: pageWidth, height: 340)
                                case .empty:
                                    ZStack {
                                        VybeColors.surfaceHover
                                        ProgressView()
                                            .tint(VybeColors.accent)
                                    }
                                    .frame(width: pageWidth, height: 340)
                                @unknown default:
                                    placeholder
                                        .frame(width: pageWidth, height: 340)
                                }
                            }
                            .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: Binding(
                    get: { currentIndex },
                    set: { if let val = $0 { currentIndex = val } }
                ))
            }
            .frame(height: 340)

            // Custom page indicator
            if imageURLs.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<imageURLs.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentIndex ? VybeColors.accent : Color.white.opacity(0.5))
                            .frame(width: index == currentIndex ? 20 : 6, height: 6)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                    }
                }
                .padding(.horizontal, VybeSpacing.sm)
                .padding(.vertical, VybeSpacing.xs)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(.bottom, VybeSpacing.sm)
            }

            // Image count badge
            HStack(spacing: VybeSpacing.xxs) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 11))
                Text("\(currentIndex + 1)/\(imageURLs.count)")
                    .font(VybeTypography.captionBold)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, VybeSpacing.xs)
            .padding(.vertical, VybeSpacing.xxs)
            .background(.ultraThinMaterial, in: Capsule())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(VybeSpacing.sm)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            fullScreenGallery
        }
    }

    private var placeholder: some View {
        ZStack {
            VybeColors.surfaceHover
            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundStyle(VybeColors.muted.opacity(0.4))
        }
    }

    // MARK: - Full Screen Gallery

    private var fullScreenGallery: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(Array(imageURLs.enumerated()), id: \.offset) { index, urlString in
                    AsyncImage(url: URL(string: urlString)) { phase in
                        if case .success(let image) = phase {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)

            Button {
                showFullScreen = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding()
            }
        }
    }
}

#Preview {
    ImageCarouselView(imageURLs: MockData.listings[0].imageURLs)
        .background(VybeColors.background)
}
