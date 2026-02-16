import Foundation

/// HTTP method types.
enum HTTPMethod: String, Sendable {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

/// Defines API endpoint configurations for type-safe networking.
struct APIEndpoint: Sendable {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]?
    let requiresAuth: Bool

    init(
        path: String,
        method: HTTPMethod = .GET,
        queryItems: [URLQueryItem]? = nil,
        requiresAuth: Bool = true
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.requiresAuth = requiresAuth
    }

    /// Constructs the full URL for this endpoint.
    func url(baseURL: String = Constants.API.baseURL) -> URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}

// MARK: - Auth Endpoints

extension APIEndpoint {
    static func login(phone: String) -> APIEndpoint {
        APIEndpoint(path: "/auth/login", method: .POST, requiresAuth: false)
    }

    static func verifyOTP(phone: String, code: String) -> APIEndpoint {
        APIEndpoint(path: "/auth/verify-otp", method: .POST, requiresAuth: false)
    }

    static func refreshToken() -> APIEndpoint {
        APIEndpoint(path: "/auth/refresh", method: .POST, requiresAuth: false)
    }

    static func signInWithApple() -> APIEndpoint {
        APIEndpoint(path: "/auth/apple", method: .POST, requiresAuth: false)
    }

    static func signInWithGoogle() -> APIEndpoint {
        APIEndpoint(path: "/auth/google", method: .POST, requiresAuth: false)
    }

    static var logout: APIEndpoint {
        APIEndpoint(path: "/auth/logout", method: .POST)
    }
}

// MARK: - Listing Endpoints

extension APIEndpoint {
    static func listings(page: Int = 1, category: String? = nil) -> APIEndpoint {
        var items = [URLQueryItem(name: "page", value: "\(page)")]
        if let category {
            items.append(URLQueryItem(name: "category", value: category))
        }
        return APIEndpoint(path: "/listings", queryItems: items, requiresAuth: false)
    }

    static func listing(id: String) -> APIEndpoint {
        APIEndpoint(path: "/listings/\(id)", requiresAuth: false)
    }

    static var createListing: APIEndpoint {
        APIEndpoint(path: "/listings", method: .POST)
    }

    static func updateListing(id: String) -> APIEndpoint {
        APIEndpoint(path: "/listings/\(id)", method: .PUT)
    }

    static func deleteListing(id: String) -> APIEndpoint {
        APIEndpoint(path: "/listings/\(id)", method: .DELETE)
    }

    static func likeListing(id: String) -> APIEndpoint {
        APIEndpoint(path: "/listings/\(id)/like", method: .POST)
    }

    static func searchListings(query: String, page: Int = 1) -> APIEndpoint {
        APIEndpoint(
            path: "/listings/search",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ],
            requiresAuth: false
        )
    }

    static var featuredListings: APIEndpoint {
        APIEndpoint(path: "/listings/featured", requiresAuth: false)
    }
}

// MARK: - User Endpoints

extension APIEndpoint {
    static var currentUser: APIEndpoint {
        APIEndpoint(path: "/users/me")
    }

    static func user(id: String) -> APIEndpoint {
        APIEndpoint(path: "/users/\(id)", requiresAuth: false)
    }

    static func userListings(userID: String) -> APIEndpoint {
        APIEndpoint(path: "/users/\(userID)/listings", requiresAuth: false)
    }

    static var updateProfile: APIEndpoint {
        APIEndpoint(path: "/users/me", method: .PUT)
    }
}

// MARK: - Chat Endpoints

extension APIEndpoint {
    static var conversations: APIEndpoint {
        APIEndpoint(path: "/conversations")
    }

    static func messages(conversationID: String, page: Int = 1) -> APIEndpoint {
        APIEndpoint(
            path: "/conversations/\(conversationID)/messages",
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        )
    }

    static func sendMessage(conversationID: String) -> APIEndpoint {
        APIEndpoint(path: "/conversations/\(conversationID)/messages", method: .POST)
    }
}

// MARK: - Offer Endpoints

extension APIEndpoint {
    static var offers: APIEndpoint {
        APIEndpoint(path: "/offers")
    }

    static func createOffer(listingID: String) -> APIEndpoint {
        APIEndpoint(path: "/listings/\(listingID)/offers", method: .POST)
    }

    static func respondToOffer(offerID: String) -> APIEndpoint {
        APIEndpoint(path: "/offers/\(offerID)/respond", method: .POST)
    }
}

// MARK: - Community Endpoints

extension APIEndpoint {
    static var communities: APIEndpoint {
        APIEndpoint(path: "/communities", requiresAuth: false)
    }

    static func community(id: String) -> APIEndpoint {
        APIEndpoint(path: "/communities/\(id)", requiresAuth: false)
    }

    static func joinCommunity(id: String) -> APIEndpoint {
        APIEndpoint(path: "/communities/\(id)/join", method: .POST)
    }
}
