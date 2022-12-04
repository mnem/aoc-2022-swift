import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day04Tests: XCTestCase {
    private var input: URL { Resource.input(day: 4, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day04.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "2")
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day04.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "4")
    }
}

