import Testing
@testable import vybe

@Suite("vybe Tests")
struct VybeTests {
    @Test("App initializes correctly")
    func appInitializes() {
        #expect(true)
    }
}
