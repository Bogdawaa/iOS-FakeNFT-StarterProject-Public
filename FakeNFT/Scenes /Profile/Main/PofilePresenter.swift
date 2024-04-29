//
//  PofilePresenter.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 08.04.2024.
//

import Foundation

final class ProfileViewPresenter: ProfilePresenterProtocol {
    // MARK: - view delegate
    weak var view: ProfileViewProtocol?
    // MARK: - PRIVATE
    private let service: ProfileService
    private var myNftId: [String] = []
    private var likedNftId: [String] = []
    private var editProfileModel: EditProfile?
    // MARK: - INIT
    init(service: ProfileService) {
        self.service = service
    }
    // MARK: - FUNC
    func viewDidLoad() {
        loadProfile()
    }
    func getMyNftId() -> [String] {
        return myNftId
    }
    func getLikedNftId() -> [String] {
        return likedNftId
    }
    func getEditProfileModel() -> EditProfile? {
        return editProfileModel
    }
    func loadProfile() {
        view?.loadingDataStarted()
        service.loadProfile(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.view?.loadingDataFinished()
                    self.view?.displayProfile(profile)
                    self.myNftId = profile.nfts
                    self.likedNftId = profile.likes
                    self.editProfileModel = EditProfile(
                        name: profile.name,
                        avatar: profile.avatar,
                        description: profile.description,
                        website: profile.website
                    )
                }
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}
