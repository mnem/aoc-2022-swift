import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day08Tests: XCTestCase {
    private var input: URL { Resource.input(day: 8, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day08.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "21")
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day08.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "8")
    }
}

