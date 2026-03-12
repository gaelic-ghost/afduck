import XCTest
@testable import afduck

final class AFDuckTests: XCTestCase {
    func testCommandParsesAudioPathArgument() throws {
        let command = try XCTUnwrap(try AFDuck.parseAsRoot(["~/example.wav"]) as? AFDuck)

        XCTAssertEqual(command.audioPath, "~/example.wav")
    }

    func testResolvedAudioURLExpandsTildeAndValidatesExistence() throws {
        let temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
        defer {
            try? FileManager.default.removeItem(at: temporaryDirectory)
        }

        let audioURL = temporaryDirectory.appendingPathComponent("sample.wav")
        try Data("test".utf8).write(to: audioURL)

        let command = try XCTUnwrap(try AFDuck.parseAsRoot([audioURL.path]) as? AFDuck)

        XCTAssertEqual(try command.resolvedAudioURL(), audioURL)
    }

    func testResolvedAudioURLThrowsForMissingFiles() throws {
        let command = try XCTUnwrap(
            try AFDuck.parseAsRoot(["/tmp/definitely-missing-audio-file.wav"]) as? AFDuck
        )

        XCTAssertThrowsError(try command.resolvedAudioURL())
    }
}
