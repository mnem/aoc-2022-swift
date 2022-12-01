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
    static func rations(list: URL) throws -> [[Int]] {
        let lines = try String(contentsOf: list).split(separator: "\n", omittingEmptySubsequences: false)
        var rations: [[Int]] = []
        var currentRation: [Int] = []
        for readLine in lines {
            let line = readLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if line.isEmpty {
                rations.append(currentRation)
                currentRation.removeAll()
            } else {
                guard let calories = Int(line) else {
                    throw "Invalid input: '\(line)'"
                }
                currentRation.append(calories)
            }
        }
        if currentRation.isEmpty == false {
            rations.append(currentRation)
        }
        return rations
    }
    
    
    struct A: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "⭐️ Day 1a"
        )
        
        @OptionGroup var options: AdventOfCode2022.Options
        
        mutating func run() async throws {
            let input = options.test ? Resource.TestInput.day01 : Resource.Input.day01
            print(try await process(input: input))
        }
        
        func process(input: URL) async throws -> String {
            let rations = try AdventOfCode2022.Day01.rations(list: input)
            let result = rations.map { $0.reduce(0, +) } .max()
            return "\(result!)"
        }
    }
}

extension AdventOfCode2022.Day01 {
    struct B: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "⭐️ Day 1b"
        )
        
        @OptionGroup var options: AdventOfCode2022.Options
        
        mutating func run() async throws {
            let input = options.test ? Resource.TestInput.day01 : Resource.Input.day01
            print(try await process(input: input))
        }
        
        func process(input: URL) async throws -> String {
            let rations = try AdventOfCode2022.Day01.rations(list: input)
            let result = rations
                .map { $0.reduce(0, +) }
                .sorted()
                .dropFirst(rations.count - 3)
                .reduce(0, +)
            return "\(result)"
        }
    }
}
