import Foundation

enum Resource {
    enum Input {
        static let day01 = Resource.input(day: 1)!
    }
    
    enum TestInput {
        static let day01 = Resource.test(day: 1)!
    }
    
    static func input(day: Int) -> URL? {
        Bundle.module.url(
                forResource: "input",
                withExtension: "txt",
                subdirectory: "Resources/day\(String(format: "%02d", day))"
        )
    }
    
    static func test(day: Int) -> URL? {
        Bundle.module.url(
                forResource: "test",
                withExtension: "txt",
                subdirectory: "Resources/day\(String(format: "%02d", day))"
        )
    }
}
