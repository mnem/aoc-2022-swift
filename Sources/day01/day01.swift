import Foundation
import ArgumentParser

extension AdventOfCode2022 {
    struct Day01: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day 1",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
    }
}

extension AdventOfCode2022.Day01 {
    struct A: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "⭐️ Day 1a")
        @OptionGroup var options: AdventOfCode2022.Options
        var input: URL { options.test ? Resource.TestInput.day01 : Resource.Input.day01 }
        
        mutating func run() async throws {
            print(try await process(input: input))
        }
        
        func process(input: URL) async throws -> String {
            let rations = try LineReader(source: input).read().toElfRations()
            let result = rations.map { $0.reduce(0, +) } .max()
            return "\(result!)"
        }
    }
}

extension AdventOfCode2022.Day01 {
    struct B: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "⭐️ Day 1b")
        @OptionGroup var options: AdventOfCode2022.Options
        var input: URL { options.test ? Resource.TestInput.day01 : Resource.Input.day01 }

        mutating func run() async throws {
            print(try await process(input: input))
        }
        
        func process(input: URL) async throws -> String {
            let rations = try LineReader(source: input).read().toElfRations()
            let result = rations
                .map { $0.reduce(0, +) }
                .sorted()
                .dropFirst(rations.count - 3)
                .reduce(0, +)
            return "\(result)"
        }
    }
}

extension Array where Element == String {
    func toElfRations() throws -> [[Int]] {
        var rations: [[Int]] = []
        var currentRation: [Int] = []
        for line in self {
            guard line.isEmpty == false else {
                rations.append(currentRation)
                currentRation.removeAll()
                continue
            }
            
            guard let calories = Int(line) else {
                throw "Invalid input: '\(line)'"
            }
            currentRation.append(calories)
        }
        if currentRation.isEmpty == false {
            rations.append(currentRation)
        }
        return rations
    }
}
