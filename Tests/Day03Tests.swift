import Foundation
import XCTest
@testable import aoc_2022_swift

final class Day03Tests: XCTestCase {
    private var input: URL { Resource.input(day: 3, test: true) }
    
    func testA() async throws {
        let sut = AdventOfCode2022.Day03.A()
        let result = try await sut.process(input: input)
        XCTAssertEqual(result, "157")
    }
    
    func testB() async throws {
        let sut = AdventOfCode2022.Day03.B()
        let result = try await sut.process(input: input)
        XCTAssertEqual(result, "70")
    }
}

