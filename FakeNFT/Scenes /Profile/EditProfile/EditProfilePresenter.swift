//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 17.04.2024.
//

import Foundation

final class EditProfilePresenter: EditProfilePresenterProtocol {
    // MARK: - EditProfileView
    weak var view: EditProfileViewProtocol?
    // MARK: - delegate
    weak var delegate: EditProfileViewControllerDelegate?
    // MARK: - PRIVATE
    private let service: EditProfileService
    private var avatarURL: String = ""
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

    func setAvatarUrl(avatarUrl: String) {
        self.avatarURL = avatarUrl
    }

    func getAvatarUrl() -> String {
        avatarURL
    }

    func setEditProfileView(view: EditProfileViewProtocol) {
        self.view = view
    }
}
