import Foundation

enum RequestConstants {
    static let baseURL = "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
    static let authToken = "20a4069e-6e51-4477-894a-e6fdc9a4bb95"
    static let authTokenHeader = "X-Practicum-Mobile-Token"

    static let timeoutInterval = Double(60) // seconds
    static let baseApiPath = "/api/v1"

    static let putContentTypeHeader = "Content-Type"
    static let putContentType = "application/x-www-form-urlencoded"

    static let defaultOrderId = "1"
    static let defaultProfileId = "1"
}
