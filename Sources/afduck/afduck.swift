import AVFAudio
import ArgumentParser
import Foundation

// MARK: - AFDuck

@main
struct AFDuck: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Duck configured media app audio, play cue sounds, then play an audio file."
    )

    @Argument(help: "Path to the audio file to play.")
    var audioPath: String

    private static let boopSoundURL = URL(fileURLWithPath: "/System/Library/Sounds/Pop.aiff")
    private static let duckShortcutName = "duck-media-app-audio"
    private static let unduckShortcutName = "unduck-media-app-audio"

    func run() throws {
        let audioURL = try resolvedAudioURL()
        let audioData = try Data(contentsOf: audioURL)

        var didDuckAudio = false
        defer {
            if didDuckAudio {
                do {
                    try Self.runShortcut(named: Self.unduckShortcutName)
                } catch {
                    fputs("warning: failed to unduck media audio: \(error)\n", stderr)
                }
            }
        }

        try Self.runShortcut(named: Self.duckShortcutName)
        didDuckAudio = true

        try Self.playSound(at: Self.boopSoundURL)
        try Self.playSound(at: Self.boopSoundURL)
        try Self.playAudio(data: audioData)
        try Self.playSound(at: Self.boopSoundURL)
        try Self.playSound(at: Self.boopSoundURL)
    }
}

// MARK: - Helpers

extension AFDuck {
    func resolvedAudioURL() throws -> URL {
        let expandedPath = NSString(string: audioPath).expandingTildeInPath
        let audioURL = URL(fileURLWithPath: expandedPath)

        guard FileManager.default.fileExists(atPath: audioURL.path) else {
            throw ValidationError("Audio file not found at path: \(expandedPath)")
        }

        return audioURL
    }

    static func playSound(at url: URL) throws {
        let player = try AVAudioPlayer(contentsOf: url)
        try play(player: player)
    }

    static func playAudio(data: Data) throws {
        let player = try AVAudioPlayer(data: data)
        try play(player: player)
    }

    static func play(player: AVAudioPlayer) throws {
        player.prepareToPlay()

        guard player.play() else {
            throw PlaybackError.failedToStart(player.url?.path)
        }

        while player.isPlaying {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.05))
        }
    }

    static func runShortcut(named name: String) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
        process.arguments = ["run", name]

        let errorPipe = Pipe()
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            let errorOutput = String(
                data: errorPipe.fileHandleForReading.readDataToEndOfFile(),
                encoding: .utf8
            )?.trimmingCharacters(in: .whitespacesAndNewlines)

            throw ShortcutError.commandFailed(
                name: name,
                status: process.terminationStatus,
                detail: errorOutput
            )
        }
    }
}

// MARK: - Errors

extension AFDuck {
    enum PlaybackError: LocalizedError {
        case failedToStart(String?)

        var errorDescription: String? {
            switch self {
            case let .failedToStart(path):
                if let path {
                    return "Failed to start playback for \(path)."
                }

                return "Failed to start playback."
            }
        }
    }

    enum ShortcutError: LocalizedError {
        case commandFailed(name: String, status: Int32, detail: String?)

        var errorDescription: String? {
            switch self {
            case let .commandFailed(name, status, detail):
                if let detail, !detail.isEmpty {
                    return "Shortcut \(name) failed with exit status \(status): \(detail)"
                }

                return "Shortcut \(name) failed with exit status \(status)."
            }
        }
    }
}
