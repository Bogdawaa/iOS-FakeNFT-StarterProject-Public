//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by admin on 09.04.2024.
//

import UIKit
import ProgressHUD

final class PaymentViewController: UIViewController {
    private var viewModel: PaymentViewModel
    private var currencyId: String?
    private var alertPresenter: AlertPresenterProtocol?
    private let link = "https://yandex.ru/legal/practicum_termsofuse/"
    private let collectionSettings = CollectionSettings(
        cellCount: 2,
        topDistance: 20,
        bottomDistance: 0,
        leftDistance: 16,
        rightDistance: 16,
        cellSpacing: 7
    )
    private let failedPayment = "Failed.Payment"
    private let errorCurrencies = "Error.Currencies"

    // MARK: - UiElements
    private lazy var navigationBar = UINavigationBar()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Select.Payment.Method", comment: "")
        label.textColor = UIColor(named: "YPBlack")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "YPBackward"), for: .normal)
        button.addTarget(self, action: #selector(backButtonActions), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(PaymentCell.self, forCellWithReuseIdentifier: "PaymentCell")
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = UIColor(named: "YPBlack")
        label.text = NSLocalizedString("User.agreement.info", comment: "")
        return label
    }()

    private lazy var linkLabel: UILabel = {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(linkAction))
        let label = UILabel()
        label.addGestureRecognizer(tapped)
        label.isUserInteractionEnabled = true
        label.font = UIFont.caption2
        label.text = NSLocalizedString("User.agreement", comment: "")
        label.textColor = UIColor(named: "YPBlue")
        return label
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitle(NSLocalizedString("Cart.Button.Pay", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "YPWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "YPBlack")
        button.addTarget(self, action: #selector(payAction), for: .touchUpInside)
        return button
    }()

    private lazy var placeholderPaymentView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(named: "YPLightGrey")
        [userAgreementLabel, linkLabel, payButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            userAgreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            linkLabel.topAnchor.constraint(equalTo: userAgreementLabel.bottomAnchor, constant: 5),
            linkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            payButton.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 20),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        return view
    }()

    // MARK: Initialisation
    init(viewModel: PaymentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewControler: self)
        configViews()
        configConstraints()
        configNavigationBar()
        bind()
        viewModel.loadCurrencies()
    }

    // MARK: Binding
    private func bind() {
        viewModel.$currencies.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.collectionView.reloadData()
            self.showLoader(isActiv: false)
        })

        viewModel.$successfulPayment.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.cartPayment()
        })

        viewModel.$paymentError.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.showAlertNetworkError(title: failedPayment)
        })

        viewModel.$errorLoadingCurrencies.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.showAlertNetworkError(title: errorCurrencies)
        })

    }

    // MARK: - Actions
    @objc private func backButtonActions() {
        dismiss(animated: true)
    }

    @objc private func linkAction() {
        guard let url = URL(string: link) else { return }
        let webView = WebViewController(link: url)
        webView.modalPresentationStyle = .fullScreen
        present(webView, animated: true)
    }

    @objc private func payAction() {
        cartPaymentAction()
    }

    // MARK: - Private methods
    private func showLoader(isActiv: Bool) {
        if isActiv {
            ProgressHUD.show(interaction: false)
        } else {
            ProgressHUD.dismiss()
        }
    }

    private func showAlertNetworkError(title: String) {
        showLoader(isActiv: false)
        let alert = AlertModel(
            title: NSLocalizedString(title, comment: ""),
            buttonTextCancel: NSLocalizedString("Cart.Alert.Cancel", comment: ""),
            buttonText: NSLocalizedString("Alert.Repeat", comment: ""),
            completion: { [weak self] in
                guard let self else { return }
                showLoader(isActiv: true)
                if title == failedPayment {
                    cartPaymentAction()
                } else {
                    viewModel.loadCurrencies()
                }
            })
        alertPresenter?.showAlert(with: alert)
    }

    private func cartPaymentAction() {
        guard let id = currencyId else { return }
        viewModel.cartPayment(currencyId: id)
    }

    private func cartPayment() {
        guard (viewModel.successfulPayment?.success) != nil else { return }
        let confirmationViewController = ConfirmationViewController()
        confirmationViewController.modalPresentationStyle = .fullScreen
        present(confirmationViewController, animated: true)
    }

    private func configNavigationBar() {
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.titleView = titleLabel
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = UIColor(named: "YPWhite")
        navigationBar.shadowImage = UIImage()
        navigationBar.setItems([navigationItem], animated: false)
    }

    private func configViews() {
        showLoader(isActiv: true)
        view.backgroundColor = UIColor(named: "YPWhite")
        [navigationBar, collectionView, placeholderPaymentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: placeholderPaymentView.topAnchor),
            placeholderPaymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placeholderPaymentView.heightAnchor.constraint(equalToConstant: 186),
            placeholderPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let items = collectionView.indexPathsForSelectedItems?.filter { $0.section == indexPath.section }
        items?.forEach {
            collectionView.deselectItem(at: $0, animated: false)
            let cell = collectionView.cellForItem(at: $0) as? PaymentCell
            cell?.selectedItem(isSelected: false)
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCell
        let selectedItem = viewModel.currencies[indexPath.item]
        currencyId = selectedItem.id
        cell?.selectedItem(isSelected: true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PaymentCell
        cell?.selectedItem(isSelected: false)
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currencies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PaymentCell",
            for: indexPath
        ) as? PaymentCell else { return UICollectionViewCell() }
        cell.configureCell(with: viewModel.currencies[indexPath.row])
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - collectionSettings.paddingWidth
        let cellWidth =  availableWidth / CGFloat(collectionSettings.cellCount)
        return CGSize(width: cellWidth, height: 46)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: collectionSettings.topDistance,
            left: collectionSettings.leftDistance,
            bottom: collectionSettings.bottomDistance,
            right: collectionSettings.rightDistance
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return collectionSettings.cellSpacing
    }
}
