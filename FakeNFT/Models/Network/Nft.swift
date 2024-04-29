import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let images: [URL]
}
