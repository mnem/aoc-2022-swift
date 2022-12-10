import Foundation
import ArgumentParser
import RegexBuilder

fileprivate let Day = 7

extension AdventOfCode2022 {
    struct Day07: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        enum Line {
            case command(Command)
            case entry(Entry)
            
            enum Command {
                case cd(path: String)
                case ls
                
                init(parts: [Substring]) throws {
                    switch parts.first {
                    case "cd": self = .cd(path: String(parts[1]))
                    case "ls": self = .ls
                    default: throw "Unknown command: \(parts)"
                    }
                }
            }
            
            enum Entry {
                case dir(name: String)
                case file(name: String, size: Int)
                
                init(parts: [Substring]) throws {
                    if parts.first == "dir" {
                        self = .dir(name: String(parts[1]))
                    } else {
                        guard let size = Int(parts[0]) else {
                            throw "Could not parse entry size for \(parts)"
                        }
                        self = .file(name: String(parts[1]), size: size)
                    }
                }
            }
            
            init(line: String) throws {
                let parts = line.split(separator: " ")
                if parts.first == "$" {
                    let command = try Command(parts: Array(parts.dropFirst()))
                    self = .command(command)
                } else {
                    self = .entry(try Entry(parts: parts))
                }
            }
        }
        
        final class FNode {
            enum Mode {
                case file(size: Int)
                case dir
            }
            
            let name: String
            let mode: Mode
            
            private (set) var children: [FNode] = []
            private (set) var parent: FNode?
            
            init(name: String, mode: Mode) {
                self.name = name
                self.mode = mode
            }
            
            func add(child: FNode) {
                child.parent = self
                children.append(child)
            }
            
            func set(parent: FNode) {
                self.parent = parent
            }
            
            func visit(_ inspect: (FNode) -> ()) {
                inspect(self)
                for child in children {
                    if case .dir = child.mode {
                        child.visit(inspect)
                    } else {
                        inspect(child)
                    }
                }
            }
            
            func allDirectories() -> [(name: String, rsize: Int)] {
                var all = [(name: String, rsize: Int)]()
                visit { node in
                    if case .dir = node.mode {
                        all.append((name: node.name, rsize: node.rsize))
                    }
                }
                return all
            }
            
            var rsize: Int {
                var total = 0
                visit { total += $0.size }
                return total
            }
            
            var size: Int {
                switch mode {
                case .dir: return 0
                case let .file(size): return size
                }
            }
        }
        
        static func parse(_ input: URL) throws -> FNode {
            let lines = try LineReader(source: input)
                .read()
                .map(Line.init)

            guard let first = lines.first,
                  case Line.command(Line.Command.cd(path: "/")) = first
            else {
                throw "Unexpected input start"
            }
            
            let root = FNode(name: "/", mode: .dir)
            var current = root
            for line in lines.dropFirst() {
                switch line {
                case .command(.cd(path: "..")): current = current.parent!
                case .command(.cd(path: "/")): current = root
                case let .command(.cd(path: path)): current = current.children.first(where: { $0.name == path })!
                case .command(.ls): break
                case let .entry(.file(name: name, size: size)): current.add(child: .init(name: name, mode:.file(size: size)))
                case let .entry(.dir(name: name)): current.add(child: .init(name: name, mode: .dir))
                }
            }
            return root
        }
        
        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options
            
            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let root = try Day07.parse(input)
                return root.allDirectories()
                    .map {$0.rsize}
                    .filter { $0 <= 100000 }
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
                let root = try Day07.parse(input)
                let diskSize = 70000000
                let updateSize = 30000000
                let unusedSize = diskSize - root.rsize
                let cleanupSize = updateSize - unusedSize
                guard cleanupSize > 0 else {
                    throw "Nothing to cleanup!"
                }
                
                return root.allDirectories()
                    .map {$0.rsize}
                    .filter { $0 >= cleanupSize }
                    .min()!
                    .toString()
            }
        }
    }
}
