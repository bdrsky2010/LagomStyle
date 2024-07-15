//
//  AddOrMoveBasketFolderViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/9/24.
//

import UIKit

import RealmSwift

final class AddOrMoveBasketFolderViewController: BaseViewController {
    
    private let addOrMoveBasketFolderView: AddOrMoveBasketFolderView
    private let viewModel: AddOrMoveBasketFolderViewModel
    
    var onChangeFolder: ((_ foler: Folder) -> Void)?
    
    init(productID: String) {
        self.addOrMoveBasketFolderView = AddOrMoveBasketFolderView()
        self.viewModel = AddOrMoveBasketFolderViewModel()
        super.init()
        bindData()
        viewModel.inputInitProductID.value = productID
    }
    
    private func bindData() {
        viewModel.outputDidConfigureNavigation.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            navigationItem.title = tuple.title
            let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: tuple.image), style: .plain, target: self, action: #selector(dismissButtonClicked))
            navigationItem.leftBarButtonItem = leftBarButtonItem
            navigationItem.leftBarButtonItem?.tintColor = LagomStyle.AssetColor.lagomBlack
        }
        
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            configureModalSize()
            configureTableView()
        }
        
        viewModel.outputDidDismiss.bind { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
    }
    
    override func loadView() {
        view = addOrMoveBasketFolderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputViewDidLoad.value = ()
    }
    
    @objc
    private func dismissButtonClicked() {
        viewModel.inputDismissButtonClicked.value = ()
    }
    
    private func configureModalSize() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
        }
    }
    
    private func configureTableView() {
        addOrMoveBasketFolderView.folderTableView.delegate = self
        addOrMoveBasketFolderView.folderTableView.dataSource = self
        addOrMoveBasketFolderView.folderTableView.register(AddOrMoveFolderTableViewCell.self, forCellReuseIdentifier: AddOrMoveFolderTableViewCell.identifier)
    }
}

extension AddOrMoveBasketFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onChangeFolder?(viewModel.outputDidFetchFolderData.value[indexPath.row + 1])
        viewModel.inputDismissButtonClicked.value = ()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputDidFetchFolderData.value.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddOrMoveFolderTableViewCell.identifier, for: indexPath) as? AddOrMoveFolderTableViewCell else { return UITableViewCell() }
        let folder = viewModel.outputDidFetchFolderData.value[indexPath.row + 1]
        let isBasket = viewModel.isProductExistFolder(folder)
        cell.configureTitle(title: folder.name)
        cell.configureImage(checkBoxImage: isBasket ? UIImage(systemName: "checkmark") : nil)
        return cell
    }
}
