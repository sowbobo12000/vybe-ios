import Foundation

/// Mock data for previews and development, matching the web app's sample data.
enum MockData {
    // MARK: - Users

    static let currentUser = UserSummary(
        id: "current-user-id",
        username: "alexjohnson",
        displayName: "Alex Johnson",
        avatarURL: nil,
        location: "San Francisco, CA",
        mannerTemperature: 38.2,
        isVerified: true,
        isOnline: true
    )

    static let users: [UserSummary] = [
        UserSummary(
            id: "user-1",
            username: "sarahchen",
            displayName: "Sarah Chen",
            location: "Berkeley, CA",
            mannerTemperature: 42.1,
            isVerified: true,
            isOnline: true
        ),
        UserSummary(
            id: "user-2",
            username: "mikepatel",
            displayName: "Mike Patel",
            location: "Oakland, CA",
            mannerTemperature: 37.8,
            isVerified: false,
            isOnline: false
        ),
        UserSummary(
            id: "user-3",
            username: "emilywang",
            displayName: "Emily Wang",
            location: "Palo Alto, CA",
            mannerTemperature: 45.3,
            isVerified: true,
            isOnline: true
        ),
        UserSummary(
            id: "user-4",
            username: "jameslee",
            displayName: "James Lee",
            location: "San Jose, CA",
            mannerTemperature: 36.5,
            isVerified: false,
            isOnline: false
        ),
        UserSummary(
            id: "user-5",
            username: "oliviabrown",
            displayName: "Olivia Brown",
            location: "Mountain View, CA",
            mannerTemperature: 39.8,
            isVerified: true,
            isOnline: true
        ),
    ]

    // MARK: - Listings

    static let listings: [ListingSummary] = [
        ListingSummary(
            id: "listing-1",
            title: "MacBook Pro 16\" M3 Max — Pristine Condition",
            price: 225000,
            originalPrice: 349900,
            category: ListingCategory.electronics.rawValue,
            condition: ListingCondition.likeNew.rawValue,
            thumbnailURL: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400",
            imageURLs: [
                "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800",
                "https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=800",
                "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800"
            ],
            sellerID: "user-1",
            sellerName: "Sarah Chen",
            sellerMannerTemp: 42.1,
            sellerLocation: "Berkeley, CA",
            viewCount: 234,
            likeCount: 45,
            offerCount: 8,
            isFeatured: true,
            location: "Berkeley, CA",
            distanceText: "2.3 mi",
            itemDescription: "Selling my 2024 MacBook Pro 16\" with M3 Max chip. 36GB unified memory, 1TB SSD. Includes original box, charger, and AppleCare+ until 2026. Battery cycle count: 42. Perfect for creative professionals.",
            createdAt: .relative(hours: 3)
        ),
        ListingSummary(
            id: "listing-2",
            title: "Vintage Leica M6 Film Camera — Collector's Edition",
            price: 350000,
            category: ListingCategory.electronics.rawValue,
            condition: ListingCondition.good.rawValue,
            thumbnailURL: "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400",
            imageURLs: [
                "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=800",
                "https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=800"
            ],
            sellerID: "user-3",
            sellerName: "Emily Wang",
            sellerMannerTemp: 45.3,
            sellerLocation: "Palo Alto, CA",
            viewCount: 189,
            likeCount: 67,
            offerCount: 3,
            isFeatured: true,
            location: "Palo Alto, CA",
            distanceText: "12 mi",
            itemDescription: "Rare 1984 Leica M6 in black chrome. Fully serviced by Leica last year. Comes with original leather case and documentation. Rangefinder is perfectly calibrated.",
            createdAt: .relative(days: 1)
        ),
        ListingSummary(
            id: "listing-3",
            title: "Nike Dunk Low Panda — Size 10 DS",
            price: 14000,
            originalPrice: 11000,
            category: ListingCategory.fashion.rawValue,
            condition: ListingCondition.brandNew.rawValue,
            thumbnailURL: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400",
            imageURLs: [
                "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800"
            ],
            sellerID: "user-2",
            sellerName: "Mike Patel",
            sellerMannerTemp: 37.8,
            sellerLocation: "Oakland, CA",
            viewCount: 95,
            likeCount: 22,
            offerCount: 5,
            location: "Oakland, CA",
            distanceText: "5.1 mi",
            itemDescription: "Deadstock Nike Dunk Low Panda in men's size 10. Comes with original box and extra laces. Purchased from Nike SNKRS app.",
            createdAt: .relative(hours: 8)
        ),
        ListingSummary(
            id: "listing-4",
            title: "Mid-Century Modern Teak Dining Table",
            price: 85000,
            category: ListingCategory.home.rawValue,
            condition: ListingCondition.good.rawValue,
            thumbnailURL: "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400",
            imageURLs: [
                "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800"
            ],
            sellerID: "user-5",
            sellerName: "Olivia Brown",
            sellerMannerTemp: 39.8,
            sellerLocation: "Mountain View, CA",
            viewCount: 156,
            likeCount: 38,
            offerCount: 2,
            location: "Mountain View, CA",
            distanceText: "18 mi",
            itemDescription: "Beautiful mid-century modern teak dining table. Seats 6 comfortably. Some minor wear consistent with age adds to the character. 72\" x 36\" x 30\".",
            createdAt: .relative(days: 2)
        ),
        ListingSummary(
            id: "listing-5",
            title: "PlayStation 5 Slim + 5 Games Bundle",
            price: 42000,
            originalPrice: 55000,
            category: ListingCategory.gaming.rawValue,
            condition: ListingCondition.likeNew.rawValue,
            thumbnailURL: "https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=400",
            imageURLs: [
                "https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=800"
            ],
            sellerID: "user-4",
            sellerName: "James Lee",
            sellerMannerTemp: 36.5,
            sellerLocation: "San Jose, CA",
            viewCount: 312,
            likeCount: 89,
            offerCount: 12,
            location: "San Jose, CA",
            distanceText: "25 mi",
            itemDescription: "PS5 Slim disc edition with 5 games: Spider-Man 2, God of War Ragnarok, Elden Ring, Baldur's Gate 3, Final Fantasy XVI. Two DualSense controllers included.",
            createdAt: .relative(hours: 5)
        ),
        ListingSummary(
            id: "listing-6",
            title: "Handmade Ceramic Vase Set — Earth Tones",
            price: 12000,
            category: ListingCategory.home.rawValue,
            condition: ListingCondition.brandNew.rawValue,
            thumbnailURL: "https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=400",
            imageURLs: [
                "https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800"
            ],
            sellerID: "user-1",
            sellerName: "Sarah Chen",
            sellerMannerTemp: 42.1,
            sellerLocation: "Berkeley, CA",
            viewCount: 67,
            likeCount: 15,
            offerCount: 1,
            location: "Berkeley, CA",
            distanceText: "2.3 mi",
            itemDescription: "Set of 3 handmade ceramic vases in beautiful earth tones. Made by a local Berkeley artist. Perfect for minimalist home decor.",
            createdAt: .relative(days: 3)
        ),
    ]

    static let featuredListings: [ListingSummary] = listings.filter(\.isFeatured)

    // MARK: - Conversations

    static let conversations: [Conversation] = [
        Conversation(
            id: "conv-1",
            participantIDs: ["current-user-id", "user-1"],
            otherUser: users[0],
            listingID: "listing-1",
            listingTitle: "MacBook Pro 16\" M3 Max",
            listingPrice: 225000,
            lastMessage: "Would you accept $2,100?",
            lastMessageAt: .relative(minutes: 15),
            unreadCount: 2
        ),
        Conversation(
            id: "conv-2",
            participantIDs: ["current-user-id", "user-3"],
            otherUser: users[2],
            listingID: "listing-2",
            listingTitle: "Vintage Leica M6",
            listingPrice: 350000,
            lastMessage: "I can meet at University Ave Starbucks tomorrow",
            lastMessageAt: .relative(hours: 2),
            unreadCount: 0
        ),
        Conversation(
            id: "conv-3",
            participantIDs: ["current-user-id", "user-2"],
            otherUser: users[1],
            listingID: "listing-3",
            listingTitle: "Nike Dunk Low Panda",
            listingPrice: 14000,
            lastMessage: "Deal! Let me know when works for pickup",
            lastMessageAt: .relative(days: 1),
            unreadCount: 1
        ),
    ]

    // MARK: - Messages

    static let messages: [Message] = [
        Message(
            id: "msg-1",
            conversationID: "conv-1",
            senderID: "current-user-id",
            senderName: "Alex Johnson",
            content: "Hi! Is the MacBook still available?",
            isRead: true,
            createdAt: .relative(hours: 1, minutes: 30)
        ),
        Message(
            id: "msg-2",
            conversationID: "conv-1",
            senderID: "user-1",
            senderName: "Sarah Chen",
            content: "Yes, it's still available! Are you interested?",
            isRead: true,
            createdAt: .relative(hours: 1, minutes: 20)
        ),
        Message(
            id: "msg-3",
            conversationID: "conv-1",
            senderID: "current-user-id",
            senderName: "Alex Johnson",
            content: "Definitely! It's in great condition?",
            isRead: true,
            createdAt: .relative(hours: 1)
        ),
        Message(
            id: "msg-4",
            conversationID: "conv-1",
            senderID: "user-1",
            senderName: "Sarah Chen",
            content: "Perfect condition. Only 42 battery cycles. I have all the original packaging and AppleCare+.",
            isRead: true,
            createdAt: .relative(minutes: 45)
        ),
        Message(
            id: "msg-5",
            conversationID: "conv-1",
            senderID: "current-user-id",
            senderName: "Alex Johnson",
            content: "Would you accept $2,100?",
            isRead: true,
            createdAt: .relative(minutes: 15)
        ),
        Message(
            id: "msg-6",
            conversationID: "conv-1",
            senderID: "user-1",
            senderName: "Sarah Chen",
            type: .offer,
            content: "Counter offer",
            offerAmount: 215000,
            isRead: false,
            createdAt: .relative(minutes: 5)
        ),
    ]

    // MARK: - Offers

    static let offers: [Offer] = [
        Offer(
            id: "offer-1",
            listingID: "listing-1",
            listingTitle: "MacBook Pro 16\" M3 Max",
            listingPrice: 225000,
            buyerID: "current-user-id",
            buyerName: "Alex Johnson",
            sellerID: "user-1",
            sellerName: "Sarah Chen",
            amount: 210000,
            status: .countered,
            message: "Would you accept $2,100?",
            counterAmount: 215000,
            createdAt: .relative(hours: 1),
            expiresAt: .relative(days: -2)
        ),
        Offer(
            id: "offer-2",
            listingID: "listing-5",
            listingTitle: "PlayStation 5 Slim + 5 Games",
            listingPrice: 42000,
            buyerID: "user-2",
            buyerName: "Mike Patel",
            sellerID: "current-user-id",
            sellerName: "Alex Johnson",
            amount: 38000,
            status: .pending,
            message: "Interested! Would you do $380?",
            createdAt: .relative(hours: 3),
            expiresAt: .relative(days: -1)
        ),
        Offer(
            id: "offer-3",
            listingID: "listing-3",
            listingTitle: "Nike Dunk Low Panda",
            listingPrice: 14000,
            buyerID: "current-user-id",
            buyerName: "Alex Johnson",
            sellerID: "user-2",
            sellerName: "Mike Patel",
            amount: 12000,
            status: .accepted,
            createdAt: .relative(days: 1)
        ),
    ]

    // MARK: - Communities

    static let communities: [Community] = [
        Community(
            id: "comm-1",
            name: "Bay Area Tech Deals",
            description: "Buy and sell tech gadgets, computers, and electronics in the SF Bay Area.",
            category: "Electronics",
            memberCount: 12500,
            listingCount: 3420,
            isJoined: true,
            isFeatured: true,
            createdAt: .relative(days: 365)
        ),
        Community(
            id: "comm-2",
            name: "Sneakerheads SF",
            description: "The go-to community for buying, selling, and trading sneakers in San Francisco.",
            category: "Fashion",
            memberCount: 8900,
            listingCount: 2100,
            isJoined: false,
            isFeatured: true,
            createdAt: .relative(days: 200)
        ),
        Community(
            id: "comm-3",
            name: "Vintage & Antiques",
            description: "For lovers of vintage finds, antique furniture, and retro collectibles.",
            category: "Collectibles",
            memberCount: 5600,
            listingCount: 1890,
            isJoined: true,
            isFeatured: false,
            createdAt: .relative(days: 300)
        ),
        Community(
            id: "comm-4",
            name: "Plant Parents Bay Area",
            description: "Swap cuttings, sell plants, and share gardening tips with fellow plant lovers.",
            category: "Home & Garden",
            memberCount: 4200,
            listingCount: 980,
            isJoined: false,
            isFeatured: true,
            createdAt: .relative(days: 150)
        ),
    ]

    // MARK: - Categories

    static let categories = ListingCategory.allCases
}
