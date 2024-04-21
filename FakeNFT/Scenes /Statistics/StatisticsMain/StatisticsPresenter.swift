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
    private let defaults = UserDefaults.standard
    private var parametr = SortParametr.byName

     // MARK: - Init

     init(service: UsersService) {
         self.service = service
     }

     func viewDidLoad() {
         parametr = getSortParametr()
         loadUsers(with: parametr)
     }

    func setUsersSortingParametr(_ parametr: SortParametr) {
        self.parametr = parametr
        saveSortParam(sortParametr: parametr)
        loadUsers(with: parametr)
    }

    func getSortParametr() -> SortParametr {
        let savedParametr = defaults.string(forKey: UserDefaultsKeys.sortParam.rawValue)
        guard let savedParametr else { return parametr }
        return SortParametr(rawValue: savedParametr) ?? parametr
    }

    func loadUsers(with parametr: SortParametr) {
        view?.loadingDataStarted()
        service.loadUsers(with: parametr) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.view?.loadingDataFinished()
                    self.view?.displayUserCells(user)
                }
            case .failure(let error):
                let errorModel = ErrorModel(
                    message: error.localizedDescription,
                    actionText: "Повторить") { [weak self] in
                        guard let self else { return }
                        self.loadUsers(with: parametr)
                }
                self.view?.showError(errorModel)
            }
        }
    }

    private func saveSortParam(sortParametr: SortParametr) {
        defaults.set(sortParametr.rawValue, forKey: UserDefaultsKeys.sortParam.rawValue)
    }
 }
