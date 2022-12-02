import Foundation

struct LineReader {
    private let source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func read(trimLines: Bool = true, skipEmpty: Bool = true) throws -> [String] {
        let lines = try String(contentsOf: source)
            .split(separator: "\n", omittingEmptySubsequences: skipEmpty)
        if trimLines {
            return lines.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        } else {
            return lines.map { String($0) }
        }
    }
}
