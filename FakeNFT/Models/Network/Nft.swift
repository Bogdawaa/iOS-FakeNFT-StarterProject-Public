import Foundation

struct Nft: Codable {
    let id: String
    let name: String
    let author: String
    let description: String
    let images: [String]
    let price: Double
    let rating: Int
    let createdAt: String

    var imagesURL: [URL] {
        images.compactMap { URL(string: $0) }
    }
}

typealias NftList = [Nft]
