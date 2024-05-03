import UIKit
import Kingfisher

final class SceletonCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: SceletonCell.self)

    private lazy var sceleton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypLightGray
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(sceleton)

        sceleton.constraintEdges(to: self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SceletonHeaderCell: UICollectionReusableView {
    static let reuseIdentifier = String(describing: SceletonHeaderCell.self)

    private lazy var sceleton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypLightGray
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(sceleton)
        NSLayoutConstraint.activate([
            sceleton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sceleton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sceleton.topAnchor.constraint(equalTo: self.topAnchor),
            sceleton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
