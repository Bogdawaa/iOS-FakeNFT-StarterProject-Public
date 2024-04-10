//
//  ProfileContract.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 08.04.2024.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol { get set }
    func displayProfile(_ profile: Profile)
    func loadingDataStarted()
    func loadingDataFinished()
}

protocol ProfilePresenterProtocol {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func loadProfile()
    func getNftId() -> [String]
}
