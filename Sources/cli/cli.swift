import ArgumentParser

@main
struct AdventOfCode2022: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "❄️ Advent of Code 2022, Swift edition ☃️",
        subcommands: [
            Day01.self, Day02.self, Day03.self, Day04.self, Day05.self,
            Day06.self, Day07.self, Day08.self, Day09.self, Day10.self,
            Day11.self,
        ],
        defaultSubcommand: Day11.self
    )
    
    struct Options: ParsableArguments {
        @Flag(name: [.long, .customShort("t")], help: "Use the test input.")
        var test = false
    }
}
