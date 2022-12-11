import Foundation
import ArgumentParser
import BigInt

fileprivate let Day = 11

extension AdventOfCode2022 {
    struct Day11: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        final class Monkey {
            typealias Item = BigInt
            
            private (set) var inspections = 0
            private var items: [Item] = []
            private let operation: (Item) -> Item
            private let test: (Item) -> Bool
            let divisor: Item
            private let trueTarget: Int
            private let falseTarget: Int
            
            init(definiton: [String]) throws {
                self.items = Parser.items(definiton[1])
                self.operation = Parser.operation(definiton[2])
                let (test, divisor) = Parser.test(definiton[3])
                self.test = test
                self.divisor = divisor
                self.trueTarget = Parser.lastInt(definiton[4])
                self.falseTarget = Parser.lastInt(definiton[5])
            }
            
            func turn(calming: (Item) -> Item) -> [(item: Item, destination: Int)] {
                let moves = items.map(operation)
                    .map(calming)
                    .map { (item: $0, destination: test($0) ? trueTarget : falseTarget ) }
                inspections += items.count
                items.removeAll()
                return moves
            }
            
            func add(item: Item) {
                items.append(item)
            }
            
            private enum Parser {
                static func items(_ line: String) -> [Item] {
                    line.split(separator: ":")[1]
                        .split(separator: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .compactMap { Item($0) }
                }
                
                static func operation(_ line: String) -> ((Item) -> Item) {
                    let parts = line.split(separator: ":")[1]
                        .split(separator: "=")[1]
                        .split(separator: " ")
                    let op = parts[1].map { $0 == "*" ? { (i: Item, k :Item) in i * k } : { (i: Item, k :Item) in i + k } }.first!
                    let constant: Item?
                    if let k = Int(parts[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
                        constant = Item(k)
                    } else {
                        constant = nil
                    }
                    return { op($0, constant ?? $0) }
                }
                
                static func test(_ line: String) -> (((Item) -> Bool), Item) {
                    let divisor = Item(line.split(separator: "by").last!.trimmingCharacters(in: .whitespacesAndNewlines))!
                    return ({ $0 % divisor == 0 }, divisor)
                }
                
                static func lastInt(_ line: String) -> Int {
                    Int(line.split(separator: " ").last!.trimmingCharacters(in: .whitespacesAndNewlines))!
                }
            }
        }
        
        static func parse(_ input: URL) throws -> [Monkey] {
            var buffer: [String] = []
            var monkeys: [Monkey] = []
            for line in try LineReader(source: input).read(skipEmpty: false) {
                if line.isEmpty && buffer.isEmpty == false {
                    monkeys.append(try Monkey(definiton: buffer))
                    buffer.removeAll(keepingCapacity: true)
                    continue
                }
                buffer.append(line)
            }
            
            if buffer.isEmpty == false {
                monkeys.append(try Monkey(definiton: buffer))
            }
            
            return monkeys
        }

        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let monkeys = try Day11.parse(input)
                let lcm = monkeys.leastCommonMultiple
                var rounds = 20
                while rounds > 0 {
                    rounds -= 1
                    for monkey in monkeys {
                        let moves = monkey.turn {
                            ($0 / 3) % lcm
                        }
                        for move in moves {
                            monkeys[move.destination].add(item: move.item)
                        }
                    }
                }
                
                let inspections = monkeys.map { $0.inspections }
                let first = inspections.max()!
                let remainingInspections = inspections.filter { $0 != first }
                let second = inspections.count - remainingInspections.count > 1 ? first : remainingInspections.max()!

                return (first * second).toString()
            }
        }
        
        struct B: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let monkeys = try Day11.parse(input)
                let lcm = monkeys.leastCommonMultiple
                var rounds = 10_000
                while rounds > 0 {
                    rounds -= 1
                    for monkey in monkeys {
                        let moves = monkey.turn {
                            $0 % lcm
                        }
                        for move in moves {
                            monkeys[move.destination].add(item: move.item)
                        }
                    }
                }

                let inspections = monkeys.map { $0.inspections }
                let first = inspections.max()!
                let remainingInspections = inspections.filter { $0 != first }
                let second = inspections.count - remainingInspections.count > 1 ? first : remainingInspections.max()!

                return (first * second).toString()
            }
        }
    }
}

extension BigInt {
    func leastCommonMultiple(with y: BigInt) -> BigInt {
        self / greatestCommonDivisor(with: y) * y
    }
}

extension Array where Element == AdventOfCode2022.Day11.Monkey {
    var leastCommonMultiple: BigInt {
        var lcm = BigInt(1)
        for monkey in self {
            lcm = lcm.leastCommonMultiple(with: monkey.divisor)
        }
        return lcm
    }
}
