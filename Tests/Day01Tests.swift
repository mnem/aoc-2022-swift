import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day01Tests: XCTestCase {
    func testA() async throws {
        let sut = AdventOfCode2022.Day01.A()
        let result = try await sut.process(input: Resource.TestInput.day01)
        XCTAssertEqual(result, "24000")
    }
    
    func testB() async throws {
        let sut = AdventOfCode2022.Day01.B()
        let result = try await sut.process(input: Resource.TestInput.day01)
        XCTAssertEqual(result, "45000")
    }
}

