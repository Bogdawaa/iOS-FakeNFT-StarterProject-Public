//
//  CartViewController.swift
//  FakeNFT
//
//  Created by admin on 25.03.2024.
//

import UIKit

protocol CartViewControllerDelegate: AnyObject {
    func removingNFTsFromCart(id: String)
}

final class CartViewController: UIViewController {
    private var activityIndicator = UIActivityIndicatorView()
    private var viewModel: CartViewModel?
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = NSLocalizedString("Сart is empty", comment: "")
        label.textColor = UIColor(named: "YP Black")
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Sort"), for: .normal)
        button.backgroundColor = .clear
        button.isHidden = true
        button.addTarget(CartViewController.self, action: #selector(sortButtonActions), for: .valueChanged)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("To pay", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.bodyBold
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "YP White"), for: .normal)
        button.backgroundColor = UIColor(named: "YP Black")
        button.addTarget(CartViewController.self, action: #selector(paymentButtonActions), for: .valueChanged)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var quantityNFTLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = UIColor(named: "YP Black")
        label.text = "0 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.text = "0 ETH"
        label.textColor = UIColor(named: "YP Green")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderPaymentView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.backgroundColor = UIColor(named: "YP LightGrey")
        view.addSubview(totalAmountLabel)
        view.addSubview(quantityNFTLabel)
        view.addSubview(paymentButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityNFTLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quantityNFTLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            totalAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalAmountLabel.topAnchor.constraint(equalTo: quantityNFTLabel.bottomAnchor),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            paymentButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            paymentButton.widthAnchor.constraint(equalToConstant: 240)
        ])
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Initialisation
    
    init(viewModel: CartViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        configViews()
        configConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.viewDidLoad()
    }
    
    // MARK: - Binding
    
    private func bind() {
        viewModel?.$nfts.bind(observer: { [weak self] _ in
            guard let self else { return }
            self.screenRenderingLogic()
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Actions
    
    @objc private func sortButtonActions() {
    }
    
    @objc private func paymentButtonActions() {
    }
    
    // MARK: - Private methods
    
    private func showLoading() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func screenRenderingLogic() {
        guard let nfts = viewModel?.nfts else { return }
        if nfts.isEmpty {
            cartIsEmpty(empty: true)
        } else {
            cartIsEmpty(empty: false)
            setTotalInfo()
        }
        hideLoading()
    }
    
    private func cartIsEmpty(empty: Bool) {
        placeholderLabel.isHidden = !empty
        placeholderPaymentView.isHidden = empty
        sortButton.isHidden = empty
        tableView.isHidden = empty
    }
    
    private func setTotalInfo() {
        guard let count = viewModel?.nfts.count else { return }
        let total = viewModel?.countingTheTotalAmount() ?? 0.0
        quantityNFTLabel.text = "\(count) NFT"
        totalAmountLabel.text = "\(total) ETH"
    }
    
    private func configViews() {
        placeholderPaymentView.backgroundColor = UIColor(named: "YP LightGrey")
        view.backgroundColor = UIColor(named: "YP White")
        view.addSubview(placeholderLabel)
        view.addSubview(sortButton)
        view.addSubview(tableView)
        view.addSubview(placeholderPaymentView)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: placeholderPaymentView.topAnchor),
            placeholderPaymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderPaymentView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.nfts.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell
        else { return UITableViewCell() }
        guard let nft = viewModel?.nfts[indexPath.row] else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configureCell(with: nft)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - CartViewControllerDelegate

extension CartViewController: CartViewControllerDelegate {
    func removingNFTsFromCart(id: String) {
        viewModel?.removeItemFromCart(idNFT: id)
    }
}