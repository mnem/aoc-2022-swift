import Foundation

struct P: CustomStringConvertible, Hashable {
    var x: Int
    var y: Int
    
    var description: String {
        "{ \(x), \(y) }"
    }

    static func +(lhs: P, rhs: P) -> P {
        .init(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }

    static func -(lhs: P, rhs: P) -> P {
        .init(
            x: lhs.x - rhs.x,
            y: lhs.y - rhs.y
        )
    }

    static func +=(lhs: inout P, rhs: P) {
        lhs = lhs + rhs
    }
}

extension Sequence where Element == P {
    func plot(marker: Character = "🟪", clear: Character = "⬜️") -> String {
        let marker = String(marker)
        let clear = String(clear)
        var minX = Int.max
        var minY = Int.max
        var maxX = Int.min
        var maxY = Int.min
        for p in self {
            minX = Swift.min(p.x, minX)
            minY = Swift.min(p.y, minY)
            maxX = Swift.max(p.x, maxX)
            maxY = Swift.max(p.y, maxY)
        }
        
        let unique = Set(self)
        var out = ""
        for y in minY...maxY {
            for x in minX...maxX {
                if unique.contains(.init(x: x, y: y)) {
                    out += marker
                } else {
                    out += clear
                }
            }
            out += "\n"
        }
        
        return out
    }
}
