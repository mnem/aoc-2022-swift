import Foundation
import ArgumentParser

fileprivate let Day = 1

extension AdventOfCode2022 {
    struct Day01: AsyncParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        struct A: AsyncParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options
            
            mutating func run() async throws {
                print(try await process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) async throws -> String {
                let rations = try LineReader(source: input).read(skipEmpty: false).toElfRations()
                let result = rations.map { $0.reduce(0, +) } .max()
                return "\(result!)"
            }
        }
        
        struct B: AsyncParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options
            
            mutating func run() async throws {
                print(try await process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) async throws -> String {
                let rations = try LineReader(source: input).read(skipEmpty: false).toElfRations()
                let result = rations
                    .map { $0.reduce(0, +) }
                    .sorted()
                    .dropFirst(rations.count - 3)
                    .reduce(0, +)
                return "\(result)"
            }
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
