import Foundation

struct NFTRequest: NetworkRequest {
    
    var secretInjector: (URLRequest) -> URLRequest
    
    var httpBody: String?

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
