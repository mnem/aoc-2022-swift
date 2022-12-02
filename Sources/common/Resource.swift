import Foundation

enum Resource {
    static func input(day: Int, test: Bool) -> URL {
        Bundle.module.url(
                forResource: test ? "test" : "input",
                withExtension: "txt",
                subdirectory: "Resources/day\(String(format: "%02d", day))"
        )!
    }
}
