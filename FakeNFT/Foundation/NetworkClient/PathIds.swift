import Foundation

enum PathIds: Equatable {
    case empty
    case one(first: String)
    case two(first: String, second: String)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case let (.one(lFirst), .one(rFirst)):
            return lFirst == rFirst
        case let (.two(lFirst, lSecond), .two(rFirst, rSecond)):
            return lFirst == rFirst && lSecond == rSecond
        default:
            return false
        }
    }
}
