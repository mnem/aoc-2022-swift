import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day06Tests: XCTestCase {
    private var input: URL { Resource.input(day: 6, test: true) }
    
    func testA() throws {
        let sut = AdventOfCode2022.Day06.A()
        let expected = ["7","5","6","10","11"]
        for (line, expected) in zip(try LineReader(source: input).read(), expected) {
            let result = try sut.process(input: line)
            XCTAssertEqual(result, expected)
        }
    }
    
    func testB() throws {
        let sut = AdventOfCode2022.Day06.B()
        let expected = ["19","23","23","29","26"]
        for (line, expected) in zip(try LineReader(source: input).read(), expected) {
            let result = try sut.process(input: line)
            XCTAssertEqual(result, expected)
        }
    }
}

