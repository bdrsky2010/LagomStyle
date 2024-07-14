//
//  AddBasketFolderViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/9/24.
//

import UIKit

final class AddBasketFolderViewController: BaseViewController {
    
    private let addBasketFolderView: AddBasketFolderView
    private let viewModel: AddBasketFolderViewModel
    
    var onAddButtonClicked: (() -> Void)?
    
    override init() {
        self.addBasketFolderView = AddBasketFolderView()
        self.viewModel = AddBasketFolderViewModel()
        super.init()
    }
    
    override func loadView() {
        view = addBasketFolderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoad.value = ()
    }
    
    private func bindData() {
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            configureModalSize()
            configureTextField()
            configureAddButton()
        }
        
        viewModel.outputDidConfigureNavigation.bind { [weak self] image in
            guard let self else { return }
            let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: image), style: .plain, target: self, action: #selector(dismissButtonClicked))
            navigationItem.leftBarButtonItem = leftBarButtonItem
            navigationItem.leftBarButtonItem?.tintColor = LagomStyle.AssetColor.lagomBlack
        }
        
        viewModel.outputDidDismiss.bind { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
        
        
        viewModel.outputDidDismissWithAddFolder.bind { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true, completion: onAddButtonClicked)
        }
        
        viewModel.outputDidCheckIsEnabledAddButton.bind { [weak self] isEnabled in
            guard let self else { return }
            addBasketFolderView.addButton.isEnabled = isEnabled
        }
    }
    
    @objc
    private func dismissButtonClicked() {
        viewModel.inputDismissButtonClicked.value = ()
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
        if let title = addBasketFolderView.titleTextField.text,
           let option = addBasketFolderView.optionTextField.text {
            viewModel.inputAddButtonClicked.value = (title, option)
        }
    }
}

extension AddBasketFolderViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == addBasketFolderView.titleTextField {
            if let text = textField.text {
                viewModel.inputIsEmptyTitleText.value = text.isEmpty
            }
        }
        if textField == addBasketFolderView.optionTextField {
            if let text = textField.text {
                viewModel.inputIsEmptyOptionText.value = text.isEmpty
            }
        }
        viewModel.inputCheckTextFields.value = ()
    }
}
