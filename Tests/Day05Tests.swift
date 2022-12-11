import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day05Tests: XCTestCase {
    private typealias SUT = AdventOfCode2022.Day05
    private var input: URL { Resource.input(day: 5, test: true) }
    
    func testA() throws {
        let sut = SUT.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "CMZ")
    }
    
    func testB() throws {
        let sut = SUT.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "MCD")
    }
}

