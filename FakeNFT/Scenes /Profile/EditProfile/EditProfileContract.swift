//
//  EditProfileContract.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 17.04.2024.
//

import Foundation

protocol EditProfileViewProtocol: AnyObject {
    var presenter: EditProfilePresenterProtocol { get set }
    func setProfile()
}

protocol EditProfilePresenterProtocol {
    var view: EditProfileViewProtocol? { get set }
    func updateProfile(editProfileModel: EditProfile)
}
