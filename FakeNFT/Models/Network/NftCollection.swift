import Foundation

struct NftCollection: Codable {
    let id: String
    let name: String
    let cover: String
    let author: String
    let nfts: [String]
    let description: String
    let createdAt: String

    var coverURL: URL? {
        URL(string: cover)
    }
}

typealias NftCollectionList = [NftCollection]

enum NftCollectionOrder: String {
    case name, nfts
}

extension NftCollection: ApiDto {
    static func listPath(ids: PathIds) -> String {
        switch ids {
        case .empty:
            return "collections"
        default:
            assertionFailure()
            return ""
        }
    }

    static func entityPath(ids: PathIds) -> String {
        switch ids {
        case let .one(first):
            return "\(listPath(ids: .empty))/\(first)"
        default:
            assertionFailure()
            return ""
        }
    }
}
