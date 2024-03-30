import AppMetricaCore
import UIKit

protocol StatLog {
    func report<T>(from screen: T.Type, event: LogEvent)
}

struct StatLogImpl: StatLog {
    func report<T>(from screen: T.Type, event: LogEvent) {
        let screenName = String(describing: screen)

        var params = ["Screen": screenName]

        switch event {
        case .open:
            print("Screen \(screenName) opened")
        case .close:
            print("Screen \(screenName) closed")
        case .click(item: let item):
            print("On screen '\(screenName)' clicked '\(item)'")
            params["Item"] = item
        }

        AppMetrica.reportEvent(
            name: event.name,
            parameters: params,
            onFailure: { error in
                print("Error when sending analytics \(error.localizedDescription)")
            }
        )
    }
}

enum LogEvent {
    case open, close, click(item: String)
    var name: String {
        switch self {
        case .open:
            "Open"
        case .close:
            "Close"
        case .click:
            "Click"
        }
    }
}

// Наследуемся от этого класса, что бы контроллер автоматом писал в метрику.
class StatLoggedUIViewController: UIViewController {
    let statLog: StatLog

    init(statLog: StatLog) {
        self.statLog = statLog
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statLog.report(from: Self.self, event: .close)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statLog.report(from: Self.self, event: .open)
    }
}
