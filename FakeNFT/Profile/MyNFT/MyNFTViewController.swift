//
//  File.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 30.03.2024.
//
import UIKit
import Foundation

final class MyNFTViewController: UIViewController {
    //MARK: - UI

    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navBarSetup()
        setupGestureRecognizers()
    }
    //MARK: - TAB BAR SETTING
    private func setupGestureRecognizers() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
    }
    private func navBarSetup() {
        if let navBar = navigationController?.navigationBar {

            let leftButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: nil)
            leftButton.tintColor = .black
            navigationItem.leftBarButtonItem = leftButton
            
            let test = UILabel()
            test.text = "Мои NFT"
            test.font = .bodyBold
            navBar.topItem?.titleView = test
            
            let rightButton = UIBarButtonItem(
                image: UIImage(named: "sortButton"),
                style: .plain,
                target: self,
                action: nil)
            rightButton.tintColor = .black
            navigationItem.rightBarButtonItem = rightButton
        }
    }
}
