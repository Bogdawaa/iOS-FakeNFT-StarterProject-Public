import UIKit
import Kingfisher

final class NftCollectionCell: UITableViewCell {
    static let reuseIdentifier = String(describing: NftCollectionCell.self)

    private lazy var rowImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.contentMode = .top
        view.clipsToBounds = true

        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 140)
        ])
        return view
    }()

    private lazy var rowLable: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.font = .bodyBold
        view.textColor = .ypBlack
        view.textAlignment = .left

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .ypWhite

        contentView.addSubview(rowImage)
        contentView.addSubview(rowLable)

        NSLayoutConstraint.activate([
            rowImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            rowImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rowImage.topAnchor.constraint(equalTo: self.topAnchor),

            rowLable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            rowLable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rowLable.topAnchor.constraint(equalTo: rowImage.bottomAnchor),
            rowLable.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initData(rowData: NftCollection) {
        rowLable.text = "\(rowData.name) (\(rowData.nfts.count))"
        rowImage.kf.setImage(with: rowData.coverURL) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                self.resizeImage()
            case .failure:
                break
            }
        }
    }

    func resizeImage() {
        guard
            let image = self.rowImage.image,
            self.rowImage.frame.width > 0
        else { return }

        self.rowImage.image = image.resizeTopAlignedToFill(newWidth: self.rowImage.frame.width)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        rowImage.kf.cancelDownloadTask()
    }
}
