import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day07Tests: XCTestCase {
    private var input: URL { Resource.input(day: 7, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day07.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "95437")
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day07.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "24933642")
    }
}

