import Foundation

struct NFTRequest: NetworkRequest {
    var httpBody: String?
    var secretInjector: (URLRequest) -> URLRequest

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
