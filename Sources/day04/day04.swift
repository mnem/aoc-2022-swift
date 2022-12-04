import Foundation
import ArgumentParser

fileprivate let Day = 4

extension AdventOfCode2022 {
    struct Day04: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        static func parse(input: URL) throws -> [[ClosedRange<Int>]] {
            try LineReader(source: input)
                .read()
                .map { $0.split(separator: ",") }
                .map { try $0.map { try $0.asRange } }
        }

        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                try Day04.parse(input: input)
                    .map { $0[0].containsOrContained(by: $0[1]) ? 1 : 0 }
                    .reduce(0, +)
                    .toString()
            }
        }
        
        struct B: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                try Day04.parse(input: input)
                    .map { $0[0].overlaps($0[1]) ? 1 : 0 }
                    .reduce(0, +)
                    .toString()
            }
        }
    }
}

extension String.SubSequence {
    var asRange: ClosedRange<Int> {
        get throws {
            let limits = self.split(separator: "-")
            guard let lower = Int(limits[0]), let upper = Int(limits[1]) else {
                throw "Could not convert '\(self)' to ClosedRange<Int>"
            }
            return lower...upper
        }
    }
}

extension ClosedRange {
    func contains(_ other: ClosedRange<Bound>) -> Bool {
        self.lowerBound <= other.lowerBound && self.upperBound >= other.upperBound
    }
    
    func containsOrContained(by other: ClosedRange<Bound>) -> Bool {
        self.contains(other) || other.contains(self)
    }
}
