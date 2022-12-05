import Foundation
import ArgumentParser
import RegexBuilder

fileprivate let Day = 5

extension AdventOfCode2022 {
    struct Day05: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        struct Stacks {
            var stack: [[Character]]
            
            init?(lines: [String]) {
                let chars = lines.map(Array.init)

                var x = 1
                var y = chars.count - 2
                let maxX = chars[y].count - 1
                var parsed = [[Character]]()
                var current = [Character]()
                while x <= maxX {
                    while y >= 0 && x < chars[y].count {
                        let crate = chars[y][x]
                        if crate == " " {
                            break
                        }
                        current.append(crate)
                        y -= 1
                    }
                    parsed.append(current)
                    current.removeAll()
                    y = chars.count - 2

                    x += 4
                }

                self.stack = parsed
            }
            
            var tops: String {
                let tops = stack.compactMap { $0.last }
                return String(tops)
            }
        }
        
        struct CrateMover9000 {
            static func go(stacks: Stacks, moves: [Move]) -> Stacks {
                var stacks = stacks
                for move in moves {
                    for _ in 0..<move.quantity {
                        let crate = stacks.stack[move.source].popLast()!
                        stacks.stack[move.destination].append(crate)
                    }
                }
                return stacks
            }
        }
        
        struct CrateMover9001 {
            static func go(stacks: Stacks, moves: [Move]) -> Stacks {
                var stacks = stacks
                for move in moves {
                    let newTop = stacks.stack[move.source].count - move.quantity
                    let moving = stacks.stack[move.source][newTop...]
                    stacks.stack[move.source] = stacks.stack[move.source].dropLast(move.quantity)
                    
                    stacks.stack[move.destination].append(contentsOf: moving)
                }
                return stacks
            }
        }

        struct Move {
            var quantity: Int
            var source: Int
            var destination: Int
            
            init?(line: String) {
                let quantity = Reference(Int.self)
                let source = Reference(Int.self)
                let destination = Reference(Int.self)
                let re = Regex {
                    "move "
                    TryCapture(as: quantity) { OneOrMore(.digit) } transform: { Int($0) }
                    " from "
                    TryCapture(as: source) { OneOrMore(.digit) } transform: { Int($0) }
                    " to "
                    TryCapture(as: destination) { OneOrMore(.digit) } transform: { Int($0) }
                }
                guard let match = line.firstMatch(of: re) else { return nil }
                
                self.quantity = match[quantity]
                self.source = match[source] - 1
                self.destination = match[destination] - 1
            }
        }
        
        static func parse(input: URL) throws -> (stacks: Stacks, moves: [Move]) {
            var stackPart: [String]?
            var buffer: [String] = []
            for line in try LineReader(source: input).read(trimLines: false, skipEmpty: false) {
                if line.isEmpty {
                    if stackPart == nil {
                        stackPart = buffer
                        buffer.removeAll()
                    }
                    continue
                }
                buffer.append(line)
            }
            
            guard stackPart?.isEmpty == false, buffer.isEmpty == false else {
                throw "Failed to parse input"
            }
            
            return (stacks: Stacks(lines: stackPart!)!, moves: buffer.compactMap(Move.init))
        }

        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let (stacks, moves) = try Day05.parse(input: input)
                return CrateMover9000.go(stacks: stacks, moves: moves).tops
            }
        }
        
        struct B: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let (stacks, moves) = try Day05.parse(input: input)
                return CrateMover9001.go(stacks: stacks, moves: moves).tops
            }
        }
    }
}
