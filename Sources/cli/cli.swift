import ArgumentParser

@main
struct AdventOfCode2022: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "❄️ Advent of Code 2022, Swift edition ☃️",
        subcommands: [Day01.self],
        defaultSubcommand: Day01.self
    )
    
    struct Options: ParsableArguments {
        @Flag(name: [.long, .customShort("t")], help: "Use the test input.")
        var test = false
    }
}
