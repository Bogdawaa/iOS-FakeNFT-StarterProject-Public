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
