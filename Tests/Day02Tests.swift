import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day02Tests: XCTestCase {
    private var input: URL { Resource.input(day: 2, test: true) }
    
    func testA() async throws {
        let sut = AdventOfCode2022.Day02.A()
        let result = try await sut.process(input: input)
        XCTAssertEqual(result, "15")
    }
    
    func testB() async throws {
        let sut = AdventOfCode2022.Day02.B()
        let result = try await sut.process(input: input)
        XCTAssertEqual(result, "12")
    }
}

