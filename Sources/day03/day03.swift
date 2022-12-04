import Foundation
import ArgumentParser
import Algorithms

fileprivate let Day = 3

extension AdventOfCode2022 {
    struct Day03: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )

        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                try LineReader(source: input)
                    .read()
                    .map { Array($0) }
                    .map { $0.bisect() }
                    .map { Set($0.0).intersection(Set($0.1)) }
                    .flatMap(Array.init)
                    .sumAsRucksackPriority
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
                try LineReader(source: input)
                    .read()
                    .map { Set(Array($0)) }
                    .chunks(ofCount: 3)
                    .flatMap {
                        let initial = $0.dropFirst().first!
                        return $0.reduce(initial) { $0.intersection($1) }
                    }
                    .sumAsRucksackPriority
                    .toString()
            }
        }
    }
}

extension Array {
    func bisect() -> (SubSequence, SubSequence) {
        guard isEmpty == false else {
            return ([], [])
        }
        let midpoint = count / 2
        return (self[..<midpoint], self[midpoint...])
    }
}

extension Character {
    private var lowerStart: UInt8 { "a".first!.asciiValue! }
    private var upperStart: UInt8 { "A".first!.asciiValue! }

    var rucksackPriority: Int {
        get throws {
            guard let ascii = self.asciiValue else { throw "Could not convert to ascii" }
            let value: UInt8 = self.isUppercase ? ascii - upperStart + 27 : ascii - lowerStart + 1
            return Int(value)
        }
    }
}

extension Array where Element == Character {
    var sumAsRucksackPriority: Int {
        get throws {
            try map { try $0.rucksackPriority } .reduce(0, +)
        }
    }
}
