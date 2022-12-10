import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day10Tests: XCTestCase {
    private var input: URL { Resource.input(day: 10, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day10.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "13140")
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day10.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result,
                       """
                       ##..##..##..##..##..##..##..##..##..##..
                       ###...###...###...###...###...###...###.
                       ####....####....####....####....####....
                       #####.....#####.....#####.....#####.....
                       ######......######......######......####
                       #######.......#######.......#######.....
                       
                       """)
    }
}

