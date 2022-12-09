import Foundation
import ArgumentParser
import RegexBuilder

fileprivate let Day = 9

extension AdventOfCode2022 {
    struct Day09: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        struct Move: CustomStringConvertible {
            var direction: P
            var count: Int
            
            init(line: String) throws {
                let parts = line.split(separator: " ")
                let direction: P
                switch parts[0] {
                case "U": direction = P(x:  0, y: -1)
                case "D": direction = P(x:  0, y:  1)
                case "L": direction = P(x: -1, y:  0)
                case "R": direction = P(x:  1, y:  0)
                default: throw "Unexpected first part"
                }
                guard let count = Int(parts[1]) else {
                    throw "Unexpected second part"
                }
                
                self.direction = direction
                self.count = count
            }
            
            var description: String {
                "[\(direction) x \(count)]"
            }
        }
        
        
        static func parse(_ input: URL) throws -> [Move] {
            try LineReader(source: input)
                .read()
                .map { try Move(line: $0) }
        }
        
        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                try Day09.parse(input)
                    .simulate(length: 2)
                    .count
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
                try Day09.parse(input)
                    .simulate(length: 10)
                    .count
                    .toString()
            }
        }
    }
}

extension P {
    func distance(to other: P ) -> P {
        .init(x: abs(x - other.x), y: abs(y - other.y))
    }
    
    fileprivate var tooFar: Bool {
        x > 1 || y > 1 || x < -1 || y < -1
    }
    
    fileprivate func move(towards other: P) throws -> P {
        let delta = other - self
        
        switch (delta.x, delta.y) {
        case let (0, dy): return self + P(x: 0, y: dy/2)
        case let (dx, 0): return self + P(x: dx/2, y: 0)
        case let (1, dy): return self + P(x: 1, y: dy/2)
        case let (dx, 1): return self + P(x: dx/2, y: 1)
        case let (-1, dy): return self + P(x: -1, y: dy/2)
        case let (dx, -1): return self + P(x: dx/2, y: -1)
        case ( 2,  2): return self + P(x:  1, y:  1)
        case ( 2, -2): return self + P(x:  1, y: -1)
        case (-2,  2): return self + P(x: -1, y:  1)
        case (-2, -2): return self + P(x: -1, y: -1)
        default: throw "Too far away: \(delta)"
        }
    }
}

extension Array where Element == AdventOfCode2022.Day09.Move {
    func simulate(length: Int) throws -> Set<P> {
        var rope = [P]()
        (0..<length).forEach { _ in
            rope.append(P(x: 0, y: 0))
        }
        
        var visited = Set<P>([rope.last!])
        for move in self {
            for _ in 0..<move.count {
                var newRope = [rope.first! + move.direction]
                for link in rope.dropFirst() {
                    let target = newRope.last!
                    if link.distance(to: target).tooFar {
                        newRope.append(try link.move(towards: target))
                    } else {
                        newRope.append(link)
                    }
                }
                rope = newRope
                visited.insert(rope.last!)
            }
        }
        return visited
    }
}
