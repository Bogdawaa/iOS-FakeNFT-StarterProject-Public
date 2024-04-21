import Foundation

struct Currency: Codable {
    let id: String
    let image: String
    let name: String
    let title: String

    var imageURL: URL? {
        URL(string: image)
    }
}

typealias CurrencyList = [Currency]
