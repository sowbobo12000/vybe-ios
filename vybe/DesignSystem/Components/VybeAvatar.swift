import SwiftUI

/// A user avatar component with initials fallback and online status indicator.
struct VybeAvatar: View {
    enum Size {
        case small   // 32pt
        case medium  // 44pt
        case large   // 64pt
        case hero    // 96pt

        var dimension: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 44
            case .large: return 64
            case .hero: return 96
            }
        }

        var font: Font {
            switch self {
            case .small: return VybeTypography.labelSmall
            case .medium: return VybeTypography.labelMedium
            case .large: return VybeTypography.heading3
            case .hero: return VybeTypography.heading1
            }
        }

        var badgeSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 14
            case .hero: return 18
            }
        }
    }

    let name: String
    var imageURL: String? = nil
    var size: Size = .medium
    var showOnlineIndicator: Bool = false
    var isOnline: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let imageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        initialsView
                    case .empty:
                        ProgressView()
                            .frame(width: size.dimension, height: size.dimension)
                    @unknown default:
                        initialsView
                    }
                }
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
            } else {
                initialsView
            }

            if showOnlineIndicator {
                Circle()
                    .fill(isOnline ? VybeColors.success : VybeColors.muted.opacity(0.5))
                    .frame(width: size.badgeSize, height: size.badgeSize)
                    .overlay {
                        Circle()
                            .stroke(VybeColors.background, lineWidth: 2)
                    }
                    .offset(x: -1, y: -1)
            }
        }
    }

    private var initialsView: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size.dimension, height: size.dimension)
            .overlay {
                Text(name.initials)
                    .font(size.font)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
    }

    /// Deterministic gradient based on name hash
    private var gradientColors: [Color] {
        let hash = abs(name.hashValue)
        let palettes: [[Color]] = [
            [VybeColors.accent, VybeColors.accentPink],
            [VybeColors.accentCyan, VybeColors.accent],
            [VybeColors.accentPink, VybeColors.accentCoral],
            [VybeColors.accentCoral, VybeColors.warning],
            [VybeColors.success, VybeColors.accentCyan],
        ]
        return palettes[hash % palettes.count]
    }
}

#Preview {
    HStack(spacing: 16) {
        VybeAvatar(name: "John Doe", size: .small, showOnlineIndicator: true, isOnline: true)
        VybeAvatar(name: "Alice Kim", size: .medium, showOnlineIndicator: true, isOnline: false)
        VybeAvatar(name: "Bob Smith", size: .large)
        VybeAvatar(name: "Charlie Brown", size: .hero)
    }
    .padding()
    .background(VybeColors.background)
}
