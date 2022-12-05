import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day05Tests: XCTestCase {
    private var input: URL { Resource.input(day: 5, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day05.A()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "CMZ")
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day05.B()
        let result = try sut.process(input: input)
        XCTAssertEqual(result, "MCD")
    }
}

