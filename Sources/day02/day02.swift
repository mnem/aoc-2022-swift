import Foundation
import ArgumentParser

fileprivate let Day = 2

extension AdventOfCode2022 {
    struct Day02: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )

        enum Shape: Int {
            case rock = 1
            case paper = 2
            case scissors = 3
            
            enum Outcome: Int {
                case win = 6
                case lose = 0
                case draw = 3
            }
            
            func against(_ other: Shape) -> Outcome {
                switch (self, other) {
                case (.rock, .rock): return .draw
                case (.rock, .paper): return .lose
                case (.rock, .scissors): return .win

                case (.paper, .rock): return .win
                case (.paper, .paper): return .draw
                case (.paper, .scissors): return .lose

                case (.scissors, .rock): return .lose
                case (.scissors, .paper): return .win
                case (.scissors, .scissors): return .draw
                }
            }
            
            func choose(for outcome: Outcome) -> Shape {
                switch (self, outcome) {
                case (.rock, .win): return .paper
                case (.rock, .draw): return .rock
                case (.rock, .lose): return .scissors

                case (.paper, .win): return .scissors
                case (.paper, .draw): return .paper
                case (.paper, .lose): return .rock

                case (.scissors, .win): return .rock
                case (.scissors, .draw): return .scissors
                case (.scissors, .lose): return .paper
                }
            }
        }

        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options
            
            func convert(string: String) -> Shape? {
                switch string.lowercased() {
                case "a", "x": return .rock
                case "b", "y": return .paper
                case "c", "z": return .scissors
                default: return nil
                }
            }

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let result = try LineReader(source: input).read().parse(shape: convert)
                    .map { $0.me.against($0.opp).rawValue + $0.me.rawValue }
                    .reduce(0, +)
                return "\(result)"
            }
        }
        
        struct B: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options

            func convert(shape: String) -> Shape? {
                switch shape.lowercased() {
                case "a": return .rock
                case "b": return .paper
                case "c": return .scissors
                default: return nil
                }
            }
            
            func convert(outcome: String) -> Shape.Outcome? {
                switch outcome.lowercased() {
                case "x": return .lose
                case "y": return .draw
                case "z": return .win
                default: return nil
                }
            }

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let result = try LineReader(source: input).read().parse(shape: convert(shape:), outcome: convert(outcome:))
                    .map { $0.outcome.rawValue + $0.opp.choose(for: $0.outcome).rawValue }
                    .reduce(0, +)
                return "\(result)"
            }
        }
    }
}

extension Array where Element == String {
    func parse(
        shape: (String) -> AdventOfCode2022.Day02.Shape?
    ) -> [(opp: AdventOfCode2022.Day02.Shape, me: AdventOfCode2022.Day02.Shape)] {
        self.map { $0.split(separator: " ") }
            .compactMap { s in
                guard let opponent = shape(String(s[0])),
                      let me = shape(String(s[1]))
                else {
                    return nil
                }
                return (opp: opponent, me: me)
            }
    }
    
    func parse(
        shape: (String) -> AdventOfCode2022.Day02.Shape?,
        outcome: (String) -> AdventOfCode2022.Day02.Shape.Outcome?
    ) -> [(opp: AdventOfCode2022.Day02.Shape, outcome: AdventOfCode2022.Day02.Shape.Outcome)] {
        self.map { $0.split(separator: " ") }
            .compactMap { s in
                guard let opponent = shape(String(s[0])),
                      let outcome = outcome(String(s[1]))
                else {
                    return nil
                }
                return (opp: opponent, outcome: outcome)
            }
    }
}
