import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day03Tests: XCTestCase {
    private typealias SUT = AdventOfCode2022.Day03
    private var input: URL { Resource.input(day: 3, test: true) }
    
    func testA() throws {
        let sut = SUT.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "157")
    }
    
    func testB() throws {
        let sut = SUT.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "70")
    }
}

