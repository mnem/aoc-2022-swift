import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day09Tests: XCTestCase {
    private var input: URL { Resource.input(day: 9, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day09.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "13")
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day09.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "1")
    }
    
    func testC() throws {
        let sut = AdventOfCode2022.Day09.B()
        let result = try sut.process(input: Resource.input(day: 9, test: true, suffix: "2"))
        XCTAssertEqual(result, "36")
    }
}

