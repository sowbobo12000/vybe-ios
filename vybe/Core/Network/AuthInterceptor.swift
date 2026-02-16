import Foundation

/// Handles automatic token injection and refresh for authenticated API requests.
/// Works in conjunction with APIClient to transparently manage auth headers.
actor AuthInterceptor {
    static let shared = AuthInterceptor()

    private var isRefreshing = false
    private var pendingRequests: [CheckedContinuation<String, Error>] = []

    private init() {}

    /// Get a valid access token, refreshing if necessary.
    func validToken() async throws -> String {
        let token = await AuthManager.shared.accessToken

        guard let token else {
            throw APIError.unauthorized
        }

        // Check if token is expired
        if await AuthManager.shared.isTokenExpired {
            return try await refreshAndWait()
        }

        return token
    }

    /// Queue up and wait for a token refresh if one is already in progress,
    /// or initiate a new refresh.
    private func refreshAndWait() async throws -> String {
        if isRefreshing {
            // Wait for the ongoing refresh to complete
            return try await withCheckedThrowingContinuation { continuation in
                pendingRequests.append(continuation)
            }
        }

        isRefreshing = true

        do {
            let success = await AuthManager.shared.refreshAccessToken()
            guard success else {
                throw APIError.unauthorized
            }

            let newToken = await AuthManager.shared.accessToken
            guard let newToken else {
                throw APIError.unauthorized
            }

            // Resume all pending requests with the new token
            for continuation in pendingRequests {
                continuation.resume(returning: newToken)
            }
            pendingRequests.removeAll()
            isRefreshing = false

            return newToken
        } catch {
            // Resume all pending requests with the error
            for continuation in pendingRequests {
                continuation.resume(throwing: error)
            }
            pendingRequests.removeAll()
            isRefreshing = false

            throw error
        }
    }
}
