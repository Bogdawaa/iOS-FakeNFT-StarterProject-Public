import UIKit

class NftCollectionDetailHeaderCell: UICollectionReusableView {
    static let reuseIdentifier = String(describing: NftCollectionDetailHeaderCell.self)

    private lazy var headImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill

        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true

        view.heightAnchor.constraint(equalToConstant: 310).isActive = true

        return view
    }()

    private lazy var headerLable: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .headline3
        return view
    }()

    private lazy var authonLink: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .caption1
        return view
    }()

    private lazy var author: UIStackView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Catalog.CollectionDetail.AuthorLable"~
        label.font = .caption2
        label.setContentHuggingPriority(.init(.infinity), for: .horizontal)

        let view = UIStackView(arrangedSubviews: [label, authonLink])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 4
        return view
    }()

    private lazy var descriptionLable: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = .caption2

        return view
    }()

    private lazy var stack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            headerLable,
            author,
            descriptionLable
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(headImage)
        addSubview(stack)

        NSLayoutConstraint.activate([
            headImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -16),
            headImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16),
            headImage.topAnchor.constraint(equalTo: self.topAnchor),

            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.topAnchor.constraint(equalTo: headImage.bottomAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(nftCollection: NftCollection) {
        headImage.kf.setImage(with: nftCollection.coverURL)
        headerLable.text = nftCollection.name
        authonLink.text = nftCollection.author
        descriptionLable.text = nftCollection.description
    }
}
