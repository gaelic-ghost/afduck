import XCTest
@testable import afduck

final class AFDuckTests: XCTestCase {
    func testCommandParsesWithoutArguments() throws {
        _ = try AFDuck.parseAsRoot([])
    }
}
