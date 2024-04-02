//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Bogdan Fartdinov on 24.03.2024.
//

 import Foundation

final class StatisticsPresenter: StatisticsPresenterProtocol {

    weak var view: StatisticsViewProtocol?

    private let service: UsersService
    private var parametr = SortParametr.byName
    private var storage = UsersStorageImpl()
    private var userStorageObserver: NSObjectProtocol?
    private var users: [User] = [User]()

     // MARK: - Init

     init(service: UsersService) {
         self.service = service
     }

     func viewDidLoad() {
         loadUsers(with: parametr)
     }

    func setUsersSortingParametr(_ parametr: SortParametr) {
        self.parametr = parametr
        loadUsers(with: parametr)
    }

    func getSortParametr() -> SortParametr {
        return parametr
    }

    func loadUsers(with parametr: SortParametr) {
         service.loadUsers(with: parametr) { [weak self] result in
             switch result {
             case .success(let user):
                 if user.isEmpty {
                     self?.view?.isEndReached = true
                 } else {
                     self?.view?.isEndReached = false
                     self?.view?.displayUserCells(user)
                 }
             case .failure(let error):
                 print("error: \(error.localizedDescription)")
             }
         }
     }
 }
