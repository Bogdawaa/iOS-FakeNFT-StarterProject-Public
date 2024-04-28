import Foundation

protocol BaseNftRequest: NetworkRequest {}

extension BaseNftRequest {
    var secretInjector: (_ request: URLRequest) -> URLRequest {
        return { request in
            var request = request
            request.setValue(RequestConstants.nftToken, forHTTPHeaderField: RequestConstants.nftHeader)
            return request
        }
    }
}
