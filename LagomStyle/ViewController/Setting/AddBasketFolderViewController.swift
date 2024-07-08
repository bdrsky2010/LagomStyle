//
//  AddBasketFolderViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/9/24.
//

import UIKit

final class AddBasketFolderViewController: BaseViewController {
    
    private let addBasketFolderView = AddBasketFolderView()
    private let realmRepository = RealmRepository()
    
    private var isTitleTextEmpty = true
    private var isOptionTextEmpty = true
    
    var onAddButtonClicked: (() -> Void)?
    
    override func loadView() {
        view = addBasketFolderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalSize()
        configureTextField()
        configureAddButton()
    }
    
    override func configureNavigation() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: LagomStyle.SystemImage.xmark), style: .plain, target: self, action: #selector(dismissButtonClicked))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = LagomStyle.AssetColor.lagomBlack
    }
    
    @objc
    private func dismissButtonClicked() {
        dismiss(animated: true)
    }
    
    private func configureModalSize() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
    }
    
    private func configureTextField() {
        addBasketFolderView.titleTextField.delegate = self
        addBasketFolderView.optionTextField.delegate = self
    }
    
    private func configureAddButton() {
        addBasketFolderView.addButton.isEnabled = false
        addBasketFolderView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func addButtonClicked() {
        let folder = Folder()
        if let title = addBasketFolderView.titleTextField.text,
           let option = addBasketFolderView.optionTextField.text {
            folder.name = title
            folder.option = option
            folder.regDate = Date()
            realmRepository.createItem(folder)
        }
        dismiss(animated: true, completion: onAddButtonClicked)
    }
}

extension AddBasketFolderViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == addBasketFolderView.titleTextField {
            if let text = textField.text {
                isTitleTextEmpty = text.isEmpty
            }
        }
        
        if textField == addBasketFolderView.optionTextField {
            if let text = textField.text {
                isOptionTextEmpty = text.isEmpty
            }
        }
        addBasketFolderView.addButton.isEnabled = (isTitleTextEmpty == false) && (isOptionTextEmpty == false)
    }
}
