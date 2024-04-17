//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 17.04.2024.
//

import Foundation

final class EditProfilePresenter: EditProfilePresenterProtocol {
    weak var view: EditProfileViewProtocol?
    // MARK: - PRIVATE
    private let service: EditProfileService
    // MARK: - INIT
    init(service: EditProfileService) {
        self.service = service
    }
    func updateProfile(editProfileModel: EditProfile) {
        service.updateProfile(editProfileModel: editProfileModel) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let profile):
                    self.view?.setProfile()
                case .failure(let error):
                    assertionFailure("\(error)")
                }
            }
        }
    }
}
