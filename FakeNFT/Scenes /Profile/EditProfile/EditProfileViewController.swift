//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Vladislav Mishukov on 04.04.2024.
//

import Foundation
import UIKit

final class EditProfileViewController: UIViewController {
    // MARK: - UI
    private lazy var editProfilecloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonDidClicked), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    private lazy var editProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 70 / 2
        imageView.clipsToBounds = true
        imageView.addoverlay()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }()
    private lazy var editProfileChangeAvatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Profile.Edit.Change.Avatar.Title"~
        label.translatesAutoresizingMaskIntoConstraints = false
        editProfileImageView.addSubview(label)
        return label
    }()
    private lazy var editProfileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.text = "Profile.Edit.NameTitle"~
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    private lazy var editProfileNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .bodyRegular
        textField.backgroundColor = .ypLightGray
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingViewLeft
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 12
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }()
    private lazy var editProfileCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.text = "Profile.Edit.CaptionTitle"~
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    private lazy var editProfileCaptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .bodyRegular
        textView.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGray
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        return textView
    }()
    private lazy var editProfileWebsiteLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.text = "Profile.Edit.WebsiteTitle"~
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }()
    private lazy var editProfileWebsiteTextField: UITextField = {
        let textField = UITextField()
        textField.font = .bodyRegular
        textField.backgroundColor = .ypLightGray
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingViewLeft
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.delegate = self
        textField.layer.cornerRadius = 12
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        return textField
    }()
    // MARK: - PRIVATE
    private var activeTextField: UITextField?
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        constraitsEditProfilecloseButton()
        constraitsEditProfileImageView()
        constraitsEditProfileNameLabel()
        constraitsEditProfileNameTextField()
        constraitsEditProfileCaptionLabel()
        constraitsEditProfileCaptionTextView()
        constraitsEditProfileWebsiteLabel()
        cosntraitsEditProfileWebsiteTextField()
        mockSetup()
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        cancelKeyboardGestureSetup()
    }
    // MARK: - OBJC
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (
            notification
                .userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue
        )?.cgRectValue else {
            return
        }
        var shouldMoveViewUp = false
        if let activeTextField {

            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        if shouldMoveViewUp {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    // MARK: - PRIVATE
    private func mockSetup() {
        editProfileImageView.image = .ypProfileImage
        editProfileNameTextField.text = "Joaquin Phoenix"
        editProfileCaptionTextView.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        editProfileWebsiteTextField.text = "Joaquin Phoenix.com"
    }
    private func cancelKeyboardGestureSetup() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    // MARK: - OBJC
    @objc
    private func closeButtonDidClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @objc
    private func hideKeyboard() {
        self.editProfileNameTextField.endEditing(true)
        self.editProfileWebsiteTextField.endEditing(true)
        self.editProfileCaptionTextView.endEditing(true)
    }
    // MARK: - CONSTRAITS
    private func constraitsEditProfilecloseButton() {
        NSLayoutConstraint.activate([
            editProfilecloseButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            editProfilecloseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            editProfilecloseButton.widthAnchor.constraint(equalToConstant: 19),
            editProfilecloseButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    private func constraitsEditProfileImageView() {
        NSLayoutConstraint.activate([
            editProfileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            editProfileImageView.topAnchor.constraint(equalTo: editProfilecloseButton.bottomAnchor, constant: 34),
            editProfileImageView.widthAnchor.constraint(equalToConstant: 70),
            editProfileImageView.heightAnchor.constraint(equalToConstant: 70),
            editProfileChangeAvatarLabel.centerXAnchor.constraint(equalTo: editProfileImageView.centerXAnchor),
            editProfileChangeAvatarLabel.centerYAnchor.constraint(equalTo: editProfileImageView.centerYAnchor)
        ])
    }
    private func constraitsEditProfileNameLabel() {
        NSLayoutConstraint.activate([
            editProfileNameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            editProfileNameLabel.topAnchor.constraint(equalTo: editProfileImageView.bottomAnchor, constant: 28)
        ])
    }
    private func constraitsEditProfileNameTextField() {
        NSLayoutConstraint.activate([
            editProfileNameTextField.leadingAnchor.constraint(equalTo: editProfileNameLabel.leadingAnchor),
            editProfileNameTextField.topAnchor.constraint(equalTo: editProfileNameLabel.bottomAnchor, constant: 6),
            editProfileNameTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            editProfileNameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func constraitsEditProfileCaptionLabel() {
        NSLayoutConstraint.activate([
            editProfileCaptionLabel.leadingAnchor.constraint(equalTo: editProfileNameTextField.leadingAnchor),
            editProfileCaptionLabel.topAnchor.constraint(equalTo: editProfileNameTextField.bottomAnchor, constant: 24)
        ])
    }
    private func constraitsEditProfileCaptionTextView() {
        NSLayoutConstraint.activate([
            editProfileCaptionTextView.leadingAnchor.constraint(equalTo: editProfileCaptionLabel.leadingAnchor),
            editProfileCaptionTextView.trailingAnchor.constraint(equalTo: editProfileNameTextField.trailingAnchor),
            editProfileCaptionTextView.topAnchor.constraint(
                equalTo: editProfileCaptionLabel.bottomAnchor,
                constant: 14
            ),
            editProfileCaptionTextView.heightAnchor.constraint(equalToConstant: 132)
        ])
    }
    private func constraitsEditProfileWebsiteLabel() {
        NSLayoutConstraint.activate([
            editProfileWebsiteLabel.leadingAnchor.constraint(equalTo: editProfileCaptionTextView.leadingAnchor),
            editProfileWebsiteLabel.topAnchor.constraint(equalTo: editProfileCaptionTextView.bottomAnchor, constant: 28)
        ])
    }
    private func cosntraitsEditProfileWebsiteTextField() {
        NSLayoutConstraint.activate([
            editProfileWebsiteTextField.leadingAnchor.constraint(equalTo: editProfileWebsiteLabel.leadingAnchor),
            editProfileWebsiteTextField.topAnchor.constraint(
                equalTo: editProfileWebsiteLabel.bottomAnchor,
                constant: 14
            ),
            editProfileWebsiteTextField.trailingAnchor.constraint(equalTo: editProfileCaptionTextView.trailingAnchor),
            editProfileWebsiteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func constraitsWebsiteTextFieldInEditing() {
        NSLayoutConstraint.activate([
            editProfileWebsiteTextField.leadingAnchor.constraint(equalTo: editProfileWebsiteLabel.leadingAnchor),
            editProfileWebsiteTextField
                .topAnchor
                .constraint(
                    equalTo: editProfileWebsiteLabel.bottomAnchor,
                    constant: 6
                ),
            editProfileWebsiteTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            editProfileWebsiteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func constraitsEditProfileWebsiteLabelInEditing() {
        editProfileWebsiteLabel.removeConstraints(editProfileWebsiteLabel.constraints)
        editProfileWebsiteLabel.removeConstraints(editProfileWebsiteLabel.constraints)
        editProfileWebsiteLabel.removeConstraints(editProfileWebsiteLabel.constraints)
        editProfileWebsiteTextField.removeConstraints(editProfileWebsiteTextField.constraints)
        editProfileNameLabel.removeConstraints(editProfileNameLabel.constraints)
        editProfileCaptionLabel.removeConstraints(editProfileCaptionLabel.constraints)
        editProfileNameTextField.removeConstraints(editProfileNameTextField.constraints)
        editProfileCaptionTextView.removeConstraints(editProfileCaptionTextView.constraints)

        NSLayoutConstraint.activate([
            editProfileWebsiteLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            editProfileWebsiteLabel.topAnchor.constraint(equalTo: editProfileImageView.bottomAnchor, constant: 28)
        ])

    }
}
// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if (textField.text?.count ?? 0) + (string.count - range.length) >= 38 {
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}
// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 200
    }
}
// MARK: - UIView extension
// This function will add a layer on any `UIView` to make that `UIView` look darkened
extension UIView {
    func addoverlay(color: UIColor = .black, alpha: CGFloat = 0.6) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
}
