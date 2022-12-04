import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day01Tests: XCTestCase {
    private var input: URL { Resource.input(day: 1, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day01.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "24000")
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day01.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "45000")
    }
}

