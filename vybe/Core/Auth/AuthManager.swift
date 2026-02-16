import Foundation

/// Manages authentication state, token storage, and user session lifecycle.
@Observable
@MainActor
final class AuthManager {
    static let shared = AuthManager()

    var isAuthenticated = false
    var currentUser: UserSummary?
    var isLoading = false
    var error: String?

    // Tokens stored in Keychain, exposed via computed properties
    var accessToken: String? {
        KeychainManager.load(key: Constants.StorageKeys.accessToken)
    }

    var refreshToken: String? {
        KeychainManager.load(key: Constants.StorageKeys.refreshToken)
    }

    var isTokenExpired: Bool {
        // In production, decode JWT and check exp claim
        // For now, always return false
        return false
    }

    private init() {
        // Check if we have a stored token on launch
        if accessToken != nil {
            isAuthenticated = true
            // Load cached user data
            currentUser = MockData.currentUser
        }
    }

    // MARK: - Auth Actions

    /// Request OTP verification code for phone login.
    func requestOTP(phone: String) async throws {
        isLoading = true
        error = nil

        // Simulate network delay
        try await Task.sleep(for: .seconds(1))
        isLoading = false
    }

    /// Verify OTP code and complete login.
    func verifyOTP(phone: String, code: String) async throws {
        isLoading = true
        error = nil

        // Simulate network delay
        try await Task.sleep(for: .seconds(1))

        // In production: call API and get tokens
        // For now, simulate successful auth
        try KeychainManager.save(key: Constants.StorageKeys.accessToken, value: "mock-access-token")
        try KeychainManager.save(key: Constants.StorageKeys.refreshToken, value: "mock-refresh-token")

        currentUser = MockData.currentUser
        isAuthenticated = true
        isLoading = false
    }

    /// Sign in with Apple.
    func signInWithApple(identityToken: Data) async throws {
        isLoading = true
        error = nil

        try await Task.sleep(for: .seconds(1))

        try KeychainManager.save(key: Constants.StorageKeys.accessToken, value: "mock-apple-token")
        try KeychainManager.save(key: Constants.StorageKeys.refreshToken, value: "mock-apple-refresh")

        currentUser = MockData.currentUser
        isAuthenticated = true
        isLoading = false
    }

    /// Refresh the access token using the refresh token.
    func refreshAccessToken() -> Bool {
        // In production: call refresh endpoint
        // For now, return true if we have a refresh token
        return refreshToken != nil
    }

    /// Log out the current user and clear all auth state.
    func logout() {
        KeychainManager.delete(key: Constants.StorageKeys.accessToken)
        KeychainManager.delete(key: Constants.StorageKeys.refreshToken)
        currentUser = nil
        isAuthenticated = false
    }

    /// For demo/development — auto-login with mock data.
    func demoLogin() {
        currentUser = MockData.currentUser
        isAuthenticated = true
    }
}
