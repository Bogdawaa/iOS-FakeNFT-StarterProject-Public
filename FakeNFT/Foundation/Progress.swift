import Foundation

struct Progress {
    var value: Float { Float(estimatedProgress) }
    var toHide: Bool { fabs(estimatedProgress - 1.0) <= 0.0001 }

    private let estimatedProgress: Double

    init(from estimatedProgress: Double) {
        self.estimatedProgress = estimatedProgress
    }
}
