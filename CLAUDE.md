# CLAUDE.md — vybe iOS Project Conventions

## Project Overview
vybe is a peer-to-peer marketplace iOS app built with Swift 6, SwiftUI, and the "Digital Aurora" design system. It follows MVVM + Clean Architecture patterns.

## Build & Run
- Open `Package.swift` in Xcode 16+ or create an Xcode project targeting iOS 17+
- All source files live under `vybe/`
- Tests live under `vybeTests/` and `vybeUITests/`

## Architecture
- **MVVM**: Each feature has a View + ViewModel pair
- **@Observable**: All ViewModels use the Observation framework (NOT ObservableObject)
- **Swift Concurrency**: All async work uses async/await — no Combine, no callbacks
- **NavigationStack**: Type-safe routing via `Route` enum and `AppRouter`
- **SwiftData**: Local persistence for caching and offline support

## Code Style
- Swift 6 strict concurrency mode
- Use `@MainActor` on all ViewModels and UI-bound classes
- Prefer value types (structs, enums) over reference types where possible
- Use extensions for protocol conformances in separate files
- Name files after the primary type they contain
- Group imports: Foundation/SwiftUI first, then project imports

## Design System
- Theme: "Digital Aurora" — pastel colors on dark backgrounds
- Always use `VybeColors`, `VybeTypography`, `VybeSpacing` tokens — never hardcode
- Glass morphism via `.ultraThinMaterial` + `GlassMorphismModifier`
- Gradient buttons use the standard lavender-to-indigo gradient
- Aurora background for hero sections

## Naming Conventions
- Views: `{Feature}View.swift` (e.g., `HomeView.swift`)
- ViewModels: `{Feature}ViewModel.swift` (e.g., `HomeViewModel.swift`)
- Components: Descriptive name (e.g., `ListingCardView.swift`)
- Design system: Prefixed with `Vybe` (e.g., `VybeButton.swift`)
- Extensions: `{Type}+{Purpose}.swift` (e.g., `Color+Vybe.swift`)

## Testing
- Unit tests for all ViewModels
- Use mock data from `MockData.swift` in tests and previews
- UI tests for critical user flows (auth, listing creation, offers)

## API
- Base URL configured in `Constants.swift`
- All endpoints defined in `APIEndpoint.swift`
- Auth tokens managed by `AuthManager` + `KeychainManager`
- WebSocket for real-time chat via `WebSocketClient`

## Git Conventions
- Branch naming: `feature/`, `fix/`, `refactor/`
- Commit messages: imperative mood, concise
- PR descriptions should reference the feature or issue
