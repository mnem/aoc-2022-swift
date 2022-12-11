import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day11Tests: XCTestCase {
    private typealias SUT = AdventOfCode2022.Day11
    private var input: URL { Resource.input(day: 11, test: true) }
    
    func testA() throws {
        let sut = SUT.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "10605")
    }
    
    func testB() throws {
        let sut = SUT.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "2713310158")
    }
}

