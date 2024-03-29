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

    private func loadUsers(with parametr: SortParametr) {
         service.loadUsers(with: parametr) { [weak self] result in
             switch result {
             case .success(let user):
                 DispatchQueue.main.async {
                     self?.view?.displayUserCells(user)
                 }
             case .failure(let error):
                 print("error: \(error.localizedDescription)")
             }
         }
     }

 }
