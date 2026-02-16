import Foundation

/// A generic async HTTP client for communicating with the vybe API.
/// Handles request construction, response parsing, error mapping, and retries.
actor APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.API.timeoutInterval
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase

        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    // MARK: - Generic Request

    /// Perform an API request and decode the response to the given type.
    func request<T: Decodable & Sendable>(
        _ endpoint: APIEndpoint,
        body: (any Encodable & Sendable)? = nil,
        retryCount: Int = 0
    ) async throws -> T {
        guard let url = endpoint.url() else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Inject auth token if required
        if endpoint.requiresAuth {
            let token = await AuthManager.shared.accessToken
            if let token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        // Encode body
        if let body {
            do {
                request.httpBody = try encoder.encode(AnyEncodable(body))
            } catch {
                throw APIError.encodingFailed(error)
            }
        }

        // Execute request
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            switch error.code {
            case .timedOut:
                throw APIError.timeout
            case .cancelled:
                throw APIError.cancelled
            default:
                throw APIError.networkError(error)
            }
        } catch {
            throw APIError.networkError(error)
        }

        // Map HTTP status codes
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            // Try token refresh
            if retryCount == 0, endpoint.requiresAuth {
                let refreshed = await AuthManager.shared.refreshAccessToken()
                if refreshed {
                    return try await self.request(endpoint, body: body, retryCount: retryCount + 1)
                }
            }
            throw APIError.unauthorized
        case 403:
            throw APIError.forbidden
        case 404:
            throw APIError.notFound
        case 429:
            let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After")
                .flatMap(TimeInterval.init)
            throw APIError.rateLimited(retryAfter: retryAfter)
        case 500...599:
            if retryCount < Constants.API.maxRetries {
                // Exponential backoff
                let delay = pow(2.0, Double(retryCount))
                try await Task.sleep(for: .seconds(delay))
                return try await self.request(endpoint, body: body, retryCount: retryCount + 1)
            }
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        default:
            let message = String(data: data, encoding: .utf8)
            throw APIError.httpError(statusCode: httpResponse.statusCode, message: message)
        }

        // Decode response
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    /// Perform an API request that doesn't return a body (e.g., DELETE).
    func requestVoid(
        _ endpoint: APIEndpoint,
        body: (any Encodable & Sendable)? = nil
    ) async throws {
        let _: EmptyResponse = try await request(endpoint, body: body)
    }
}

// MARK: - Helper Types

/// A type-erased Encodable wrapper for sending heterogeneous request bodies.
private struct AnyEncodable: Encodable, @unchecked Sendable {
    private let _encode: (Encoder) throws -> Void

    init(_ wrapped: any Encodable & Sendable) {
        _encode = { encoder in
            try wrapped.encode(to: encoder)
        }
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

/// An empty response body for void API calls.
private struct EmptyResponse: Decodable {}
