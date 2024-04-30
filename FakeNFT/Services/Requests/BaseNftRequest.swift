import Foundation

protocol BaseNftRequest: NetworkRequest {}

extension BaseNftRequest {
    var secretInjector: (_ request: URLRequest) -> URLRequest {
        return { request in
            var request = request
            request.setValue(RequestConstants.authToken, forHTTPHeaderField: RequestConstants.authTokenHeader)
            return request
        }
    }
}
