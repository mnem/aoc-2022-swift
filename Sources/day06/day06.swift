import Foundation
import ArgumentParser
import RegexBuilder

fileprivate let Day = 6

extension AdventOfCode2022 {
    struct Day06: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        static func parse(_ input: URL) throws -> String {
            try LineReader(source: input).read().first!
        }

        static func findMarker(in stream: String, markerLength: Int) throws -> Int {
            var position = 0
            for window in stream.windows(ofCount: markerLength) {
                if Set(window).count == markerLength {
                    return (position + markerLength)
                }
                position += 1
            }
            throw "No marker found"
        }
        
        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Day06.parse(Resource.input(day: Day, test: options.test))))
            }
            
            func process(input: String) throws -> String {
                try Day06
                    .findMarker(in: input, markerLength: 4)
                    .toString()
            }
        }
        
        struct B: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Day06.parse(Resource.input(day: Day, test: options.test))))
            }
            
            func process(input: String) throws -> String {
                try Day06
                    .findMarker(in: input, markerLength: 14)
                    .toString()
            }
        }
    }
}
