import AuthenticationServices
import SwiftUI

/// Manages OAuth sign-in flows for Apple and Google.
@MainActor
final class OAuthManager: NSObject {
    static let shared = OAuthManager()

    private var appleSignInContinuation: CheckedContinuation<ASAuthorization, Error>?

    private override init() {
        super.init()
    }

    // MARK: - Apple Sign-In

    /// Present the Apple Sign-In flow and return the authorization result.
    func signInWithApple() async throws -> ASAuthorization {
        return try await withCheckedThrowingContinuation { continuation in
            self.appleSignInContinuation = continuation

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension OAuthManager: ASAuthorizationControllerDelegate {
    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task { @MainActor in
            appleSignInContinuation?.resume(returning: authorization)
            appleSignInContinuation = nil
        }
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            appleSignInContinuation?.resume(throwing: error)
            appleSignInContinuation = nil
        }
    }
}
