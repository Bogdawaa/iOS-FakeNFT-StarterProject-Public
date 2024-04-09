//
//  PofilePresenter.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 08.04.2024.
//

import Foundation

final class ProfileViewPresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    // MARK: - PRIVATE
    private let service: ProfileService
    // MARK: - INIT
    init(service: ProfileService) {
        self.service = service
    }
    func viewDidLoad() {
        loadProfile()
    }
    // MARK: - FUNC
    func loadProfile() {
        view?.loadingDataStarted()
        service.loadProfile(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.view?.loadingDataFinished()
                    self.view?.displayProfile(profile)
                }
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}
