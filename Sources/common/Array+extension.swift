extension Array where Element == String {
    func parse<T>(parser: (String) -> T) -> [T] {
        self.map(parser)
    }
}
