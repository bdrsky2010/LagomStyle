//
//  AddOrMoveBasketFolderViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/9/24.
//

import UIKit

import RealmSwift

final class AddOrMoveBasketFolderViewController: BaseViewController {
    
    private let addOrMoveBasketFolderView = AddOrMoveBasketFolderView()
    private let realmRepository = RealmRepository()
    
    private var folderList: Results<Folder>!
    
    var productID: String?
    var onChangeFolder: ((_ foler: Folder) -> Void)?
    
    override func loadView() {
        view = addOrMoveBasketFolderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalSize()
        configureFolder()
        configureTableView()
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
            sheetPresentationController.detents = [.medium(), .large()]
        }
    }
    
    private func configureFolder() {
        folderList = realmRepository.fetchItem(of: Folder.self)
    }
    
    private func configureTableView() {
        addOrMoveBasketFolderView.folderTableView.delegate = self
        addOrMoveBasketFolderView.folderTableView.dataSource = self
        addOrMoveBasketFolderView.folderTableView.register(AddOrMoveFolderTableViewCell.self, forCellReuseIdentifier: AddOrMoveFolderTableViewCell.identifier)
    }
}

extension AddOrMoveBasketFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onChangeFolder?(folderList[indexPath.row + 1])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddOrMoveFolderTableViewCell.identifier, for: indexPath) as? AddOrMoveFolderTableViewCell else { return UITableViewCell() }
        let folder = folderList[indexPath.row + 1]
        let isBasket = folder.detail.contains(where: { $0.id == productID })
        cell.configureTitle(title: folder.name)
        cell.configureImage(checkBoxImage: isBasket ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"))
        return cell
    }
    
    
}
