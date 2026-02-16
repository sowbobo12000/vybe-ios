import CoreLocation
import SwiftUI

/// A wrapper around CLLocationManager that provides async location access.
@Observable
@MainActor
final class LocationManager: NSObject {
    static let shared = LocationManager()

    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationName: String = "San Francisco, CA"
    var isLoading = false
    var error: String?

    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 500 // Update every 500 meters
    }

    // MARK: - Permission

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    var hasPermission: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    // MARK: - Location

    /// Request a single location update.
    func requestLocation() async throws -> CLLocation {
        guard hasPermission else {
            requestPermission()
            throw LocationError.permissionDenied
        }

        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
        }
    }

    /// Start continuous location updates.
    func startUpdating() {
        guard hasPermission else {
            requestPermission()
            return
        }
        manager.startUpdatingLocation()
    }

    /// Stop continuous location updates.
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    /// Reverse geocode a location to get a human-readable address.
    func reverseGeocode(_ location: CLLocation) async -> String? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                return city.isEmpty ? state : "\(city), \(state)"
            }
        } catch {
            // Silently fail — location name is not critical
        }
        return nil
    }

    /// Calculate distance between current location and a coordinate pair.
    func distanceTo(latitude: Double, longitude: Double) -> Double? {
        guard let current = currentLocation else { return nil }
        let target = CLLocation(latitude: latitude, longitude: longitude)
        return current.distance(from: target)
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            self.currentLocation = location
            self.isLoading = false

            if let name = await self.reverseGeocode(location) {
                self.locationName = name
            }

            self.locationContinuation?.resume(returning: location)
            self.locationContinuation = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.error = error.localizedDescription
            self.isLoading = false

            self.locationContinuation?.resume(throwing: error)
            self.locationContinuation = nil
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
        }
    }
}

// MARK: - Location Errors

enum LocationError: LocalizedError {
    case permissionDenied
    case locationUnavailable

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission is required to show nearby listings."
        case .locationUnavailable:
            return "Unable to determine your location."
        }
    }
}
