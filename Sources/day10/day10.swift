import Foundation
import ArgumentParser
import RegexBuilder
import Algorithms

fileprivate let Day = 10

extension AdventOfCode2022 {
    struct Day10: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "🎄 Day \(Day)",
            subcommands: [A.self, B.self],
            defaultSubcommand: B.self
        )
        
        enum Microcode {
            case noop
            case addx
            case literal(Int)
            
            static func parse(_ string: String) throws -> [Microcode] {
                let parts = string.split(separator: " ")
                guard let operand = parts.first else {
                    throw "Failed to parse '\(string)'"
                }
                switch operand {
                case "noop":
                    return [.noop]
                case "addx":
                    guard parts.count > 1,  let literal = Int(parts[1]) else {
                        throw "Malformed addx: '\(string)'"
                    }
                    return [.addx, .literal(literal)]
                default: throw "Unrecognised opcode '\(string)'"
                }
            }
        }
        
        final class CPU {
            private (set) var rx = 1
            private let rom: [Microcode]
            
            init(rom: [Microcode]) {
                self.rom = rom
            }
            
            private func execute(_ m: Microcode, previous: Microcode?) throws -> Microcode {
                switch m {
                case .noop: break
                case .addx: break
                case let .literal(n):
                    guard case .addx = previous else {
                        throw "Unexpected code before literal: \(String(describing: previous))"
                    }
                    rx += n
                }
                return m
            }
            
            func run(monitor: (_ cpu: CPU, _ cycle: Int) -> Void ) throws {
                rx = 1
                var last: Microcode?
                for cycle in 1...rom.count {
                    monitor(self, cycle)
                    last = try execute(rom[cycle - 1], previous: last)
                }
            }
            
        }
        
        static func parse(_ input: URL) throws -> [Microcode] {
            try LineReader(source: input)
                .read()
                .flatMap(Microcode.parse)
        }

        struct A: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)a")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let stream = try Day10.parse(input)
                let machine = CPU(rom: stream)
                var nextSample = 20
                var samples = [Int]()
                try machine.run { cpu, cycle in
                    if cycle - nextSample == 0 {
                        samples.append(cycle * cpu.rx)
                        nextSample += 40
                    }
                }
                return samples.reduce(0, +).toString()
            }
        }
        
        struct B: ParsableCommand {
            static var configuration = CommandConfiguration(abstract: "⭐️ Day \(Day)b")
            @OptionGroup var options: AdventOfCode2022.Options

            mutating func run() throws {
                print(try process(input: Resource.input(day: Day, test: options.test)))
            }
            
            func process(input: URL) throws -> String {
                let stream = try Day10.parse(input)
                let machine = CPU(rom: stream)
                let width = 40
                let height = 6
                var pixels = Array(repeating: false, count: width * height)
                try machine.run { cpu, cycle in
                    let scan = (cycle - 1) % pixels.count
                    let line = scan % width
                    pixels[scan] = (line >= cpu.rx - 1 && line <= cpu.rx + 1)
                }
                
                print(render(buffer: pixels, width: width, on: "🟩", off: "⬛️"))

                return render(buffer: pixels, width: width)
            }
            
            private func render(buffer: [Bool], width: Int, on: Character = "#", off: Character = ".") -> String {
                var out = ""
                for line in buffer.chunks(ofCount: width) {
                    out += String(line.map { $0 ? on : off }) + "\n"
                }
                return out
            }
        }
    }
}

extension AdventOfCode2022.Day10.Microcode: CustomStringConvertible {
    var description: String {
        switch self {
        case .noop: return "noop"
        case .addx: return "addx"
        case let .literal(n): return "#(\(n))"
        }
    }
}

extension Array where Element == AdventOfCode2022.Day10.Microcode {
    var disassembly: String {
        var out = ""
        for m in self {
            switch m {
            case .noop, .literal:
                out += "\(m)\n"
            case .addx:
                out += "\(m) "
            }
        }
        return out
    }
    
    var raw: String {
        var out = ""
        var cycle = 1
        var mark = 20
        for m in self {
            out += "\(String(format: "%03d", cycle)): \(m)  \(cycle == mark ? "⬅️" : "")\n"
            if cycle == mark {
                mark += 40
            }
            cycle += 1
        }
        return out
    }
}
