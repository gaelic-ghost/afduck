import ArgumentParser

// MARK: - AFDuck

@main
struct AFDuck: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A command-line entry point for the afduck tool package."
    )

    mutating func run() throws {
        print("Hello, world!")
    }
}
