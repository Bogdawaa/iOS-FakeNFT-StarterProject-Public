import Foundation

// swiftlint:disable nslocalizedstring_key
postfix operator ~
postfix func ~ (string: String) -> String {
    NSLocalizedString(string, comment: "")
}
// swiftlint:enable nslocalizedstring_key
