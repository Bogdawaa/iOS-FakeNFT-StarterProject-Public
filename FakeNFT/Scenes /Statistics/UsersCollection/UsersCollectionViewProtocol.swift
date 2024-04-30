//
//  UsersCollectionContract.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 21.04.2024.
//

import UIKit

protocol UsersCollectionViewProtocol: AnyObject, ErrorView, LoadingView {
    var presenter: UsersCollectionPresenterProtocol { get set }
    func reloadCollectionView()
    func loadingDataStarted()
    func loadingDataFinished()
}
