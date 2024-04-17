import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    NSLocalizedString(string, comment: "")
}
