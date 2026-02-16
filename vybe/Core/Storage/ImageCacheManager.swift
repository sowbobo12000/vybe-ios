import SwiftUI

/// An in-memory and disk image cache for listing and user images.
actor ImageCacheManager {
    static let shared = ImageCacheManager()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("vybe_image_cache", isDirectory: true)

        // Create cache directory if needed
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }

        // Configure memory cache limits
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }

    // MARK: - Cache Operations

    /// Load an image from cache (memory first, then disk).
    func image(for url: String) -> UIImage? {
        let key = cacheKey(for: url)

        // Check memory cache
        if let cached = memoryCache.object(forKey: key as NSString) {
            return cached
        }

        // Check disk cache
        let filePath = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            // Promote to memory cache
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }

        return nil
    }

    /// Store an image in both memory and disk cache.
    func store(_ image: UIImage, for url: String) {
        let key = cacheKey(for: url)

        // Memory cache
        memoryCache.setObject(image, forKey: key as NSString)

        // Disk cache
        let filePath = cacheDirectory.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: filePath)
        }
    }

    /// Remove a specific cached image.
    func remove(for url: String) {
        let key = cacheKey(for: url)
        memoryCache.removeObject(forKey: key as NSString)
        let filePath = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: filePath)
    }

    /// Clear all cached images.
    func clearAll() {
        memoryCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    // MARK: - Helpers

    private func cacheKey(for url: String) -> String {
        // Create a filename-safe hash of the URL
        let hash = url.data(using: .utf8)?.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .prefix(64)
        return String(hash ?? "unknown")
    }
}
