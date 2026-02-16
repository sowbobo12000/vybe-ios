import SwiftUI

/// Spacing tokens for consistent layout throughout the app.
enum VybeSpacing {
    /// 2pt — Minimal spacing
    static let xxxs: CGFloat = 2
    /// 4pt — Tight spacing
    static let xxs: CGFloat = 4
    /// 8pt — Small spacing
    static let xs: CGFloat = 8
    /// 12pt — Compact spacing
    static let sm: CGFloat = 12
    /// 16pt — Default spacing
    static let md: CGFloat = 16
    /// 20pt — Medium-large spacing
    static let lg: CGFloat = 20
    /// 24pt — Large spacing
    static let xl: CGFloat = 24
    /// 32pt — Extra-large spacing
    static let xxl: CGFloat = 32
    /// 48pt — Section spacing
    static let xxxl: CGFloat = 48
    /// 64pt — Hero spacing
    static let huge: CGFloat = 64

    // MARK: - Corner Radii

    /// 4pt corner radius
    static let radiusXS: CGFloat = 4
    /// 8pt corner radius
    static let radiusSM: CGFloat = 8
    /// 12pt corner radius
    static let radiusMD: CGFloat = 12
    /// 16pt corner radius
    static let radiusLG: CGFloat = 16
    /// 20pt corner radius
    static let radiusXL: CGFloat = 20
    /// 24pt corner radius
    static let radiusXXL: CGFloat = 24
    /// Full pill shape
    static let radiusFull: CGFloat = 999

    // MARK: - Standard Insets

    static let screenHorizontal: CGFloat = 16
    static let screenVertical: CGFloat = 12
    static let cardPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    static let listItemSpacing: CGFloat = 12
    static let gridSpacing: CGFloat = 12

    /// Standard screen-edge padding
    static var screenInsets: EdgeInsets {
        EdgeInsets(
            top: screenVertical,
            leading: screenHorizontal,
            bottom: screenVertical,
            trailing: screenHorizontal
        )
    }
}
