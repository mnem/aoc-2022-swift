import Foundation
import ArgumentParser
import RegexBuilder

fileprivate let Day = 8

extension AdventOfCode2022 {
    struct Day08: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        static func parse(_ input: URL) throws -> [[Int]] {
            try LineReader(source: input)
                .read()
                .map { line in
                    line.map { Int(String($0))! }
                }
        }
        
        struct Drone {
            struct P: Hashable {
                var x = 0
                var y = 0
                
                static func +(lhs: P, rhs: P) -> P {
                    .init(
                        x: lhs.x + rhs.x,
                        y: lhs.y + rhs.y
                    )
                }
                
                static func +=(lhs: inout P, rhs: P) {
                    lhs = lhs + rhs
                }
                
            }
            
            let patch: [[Int]]
            
            init(patch: [[Int]]) {
                self.patch = patch
            }
            
            private func inBounds(_ p: P) -> Bool {
                p.x >= 0
                && p.y >= 0
                && p.x < patch.first!.count
                && p.y < patch.count
            }
            
            func visible(tree: P) -> Bool {
                let height = patch[tree.y][tree.x]
                let scanners = [P(x:1, y:0), P(x:-1, y:0), P(x:0, y:1), P(x:0, y:-1)]
                
                for scanner in scanners {
                    var test = tree + scanner
                    while inBounds(test) {
                        if patch[test.y][test.x] < height {
                            test += scanner
                        } else {
                            break
                        }
                    }
                    if !inBounds(test) {
                        return true
                    }
                }
                
                return false
            }
            
            func score(tree: P) -> Int {
                let height = patch[tree.y][tree.x]
                let scanners = [P(x:1, y:0), P(x:-1, y:0), P(x:0, y:1), P(x:0, y:-1)]
                var counts: [Int] = []
                
                for scanner in scanners {
                    var count = 0
                    var test = tree + scanner
                    while inBounds(test) {
                        count += 1
                        if patch[test.y][test.x] >= height {
                            break
                        } else {
                            test += scanner
                        }
                    }
                    counts.append(count)
                }
                
                return counts.reduce(1, *)
            }
            
            func visit(_ processor: (Int, Int) -> ()) {
                let sideX = patch.first!.count
                let sideY = patch.count
                
                for y in 0..<sideY {
                    for x in 0..<sideX {
                        processor(x, y)
                    }
                }
            }
        }

        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let drone = Drone(patch: try Day08.parse(input))
                var seen = Set<Drone.P>()
                drone.visit { x, y in
                    let tree = Drone.P(x: x,  y: y)
                    if drone.visible(tree: tree) {
                        seen.insert(tree)
                    }
                }
                
                return seen.count.toString()
            }
        }
        
        struct B: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let drone = Drone(patch: try Day08.parse(input))
                var scores: [Int] = []
                drone.visit { x, y in
                    scores.append(drone.score(tree: .init(x: x,  y: y)))
                }
                
                return scores.max()!.toString()
            }
        }
    }
}
