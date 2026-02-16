import Foundation

/// Typed API errors for consistent error handling across the app.
enum APIError: LocalizedError, Sendable {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case decodingFailed(Error)
    case encodingFailed(Error)
    case httpError(statusCode: Int, message: String?)
    case unauthorized
    case forbidden
    case notFound
    case rateLimited(retryAfter: TimeInterval?)
    case serverError(statusCode: Int)
    case networkError(Error)
    case timeout
    case cancelled
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidRequest:
            return "The request could not be constructed."
        case .invalidResponse:
            return "The server response is invalid."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .httpError(let statusCode, let message):
            return "HTTP \(statusCode): \(message ?? "Unknown error")"
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .forbidden:
            return "You don't have permission to access this resource."
        case .notFound:
            return "The requested resource was not found."
        case .rateLimited:
            return "Too many requests. Please try again shortly."
        case .serverError(let statusCode):
            return "Server error (\(statusCode)). Please try again later."
        case .networkError:
            return "A network error occurred. Check your connection."
        case .timeout:
            return "The request timed out. Please try again."
        case .cancelled:
            return "The request was cancelled."
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }

    /// Whether the error is recoverable via retry
    var isRetryable: Bool {
        switch self {
        case .timeout, .networkError, .serverError, .rateLimited:
            return true
        default:
            return false
        }
    }
}
