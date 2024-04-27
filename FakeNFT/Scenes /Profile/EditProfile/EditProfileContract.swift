//
//  EditProfileContract.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 17.04.2024.
//

import Foundation

protocol EditProfileViewProtocol: AnyObject {
    func setDelegate(delegate: EditProfileViewControllerDelegate)
    func setProfile()
}

protocol EditProfilePresenterProtocol {
    var view: EditProfileViewProtocol? { get }
    var delegate: EditProfileViewControllerDelegate? { get set }

    func updateProfile(editProfileModel: EditProfile)
    func setAvatarUrl(avatarUrl: String)
    func getAvatarUrl() -> String
    func setEditProfileView(view: EditProfileViewProtocol)
}
