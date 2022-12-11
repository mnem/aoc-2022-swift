import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day01Tests: XCTestCase {
    private typealias SUT = AdventOfCode2022.Day01
    private var input: URL { Resource.input(day: 1, test: true) }
    
    func testA() throws {
        let sut = SUT.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "24000")
    }
    
    func testB() throws {
        let sut = SUT.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "45000")
    }
}

