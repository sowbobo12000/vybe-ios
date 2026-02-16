import Foundation

/// ViewModel for the listing detail screen.
@Observable
@MainActor
final class ListingDetailViewModel {
    var listing: ListingSummary?
    var isLoading = false
    var error: String?
    var showOfferModal = false
    var offerAmount = ""
    var offerMessage = ""
    var isSubmittingOffer = false

    private let listingID: String

    init(listingID: String) {
        self.listingID = listingID
        Task { await loadListing() }
    }

    func loadListing() async {
        isLoading = true
        error = nil

        try? await Task.sleep(for: .milliseconds(400))

        if let found = MockData.listings.first(where: { $0.id == listingID }) {
            listing = found
        } else {
            error = "Listing not found"
        }
        isLoading = false
    }

    func toggleLike() {
        guard var listing else { return }
        listing.isLiked.toggle()
        listing.likeCount += listing.isLiked ? 1 : -1
        self.listing = listing
    }

    func submitOffer() async {
        guard let listing else { return }
        guard let amount = Int(offerAmount), amount > 0 else { return }

        isSubmittingOffer = true
        try? await Task.sleep(for: .milliseconds(800))

        // In production: call APIClient to create the offer
        print("[vybe] Offer submitted: $\(amount) on \(listing.title)")

        isSubmittingOffer = false
        showOfferModal = false
        offerAmount = ""
        offerMessage = ""
    }

    func shareListing() {
        // Would open share sheet with listing URL
    }

    func reportListing() {
        // Would open report flow
    }
}
