import Foundation

enum Resource {
    static func input(day: Int, test: Bool, suffix: String = "") -> URL {
        Bundle.module.url(
                forResource: test ? "test" + suffix : "input" + suffix,
                withExtension: "txt",
                subdirectory: "Resources/day\(String(format: "%02d", day))"
        )!
    }
}
