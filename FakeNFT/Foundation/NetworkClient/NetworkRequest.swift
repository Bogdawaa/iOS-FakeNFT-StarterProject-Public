import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    var httpBody: String? { get }
    var secretInjector: (_ request: URLRequest) -> URLRequest { get }
    var parametrs: [String: String]? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var authToken: String? { RequestConstants.authToken }
    var application: String? { RequestConstants.putContentType }
    var parametrs: [String: String]? { nil }
}
