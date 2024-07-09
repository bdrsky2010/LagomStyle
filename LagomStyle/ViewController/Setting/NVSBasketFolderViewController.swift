//
//  NVSBasketFolderViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import UIKit

import RealmSwift

final class NVSBasketFolderViewController: BaseViewController {
    
    private let nvsBasketFolderView = NVSBasketFolderView()
    private let realmRepository = RealmRepository()
    
    private var folder: Results<Folder>!
    
    override func loadView() {
        view = nvsBasketFolderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFolder()
        configureTableView()
    }
    
    override func configureNavigation() {
        navigationItem.title = "장바구니 폴더 목록"
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: LagomStyle.SystemImage.plus), style: .plain, target: self, action: #selector(plusButtonClicked))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    private func plusButtonClicked() {
        let addBasketFolderViewController = AddBasketFolderViewController()
        addBasketFolderViewController.onAddButtonClicked = { [weak self] in
            guard let self else { return }
            nvsBasketFolderView.folderTableView.reloadData()
        }
        let navigationController = UINavigationController(rootViewController: addBasketFolderViewController)
        present(navigationController, animated: true)
    }
    
    private func configureFolder() {
        folder = realmRepository.fetchItem(of: Folder.self)
    }
    
    private func configureTableView() {
        nvsBasketFolderView.folderTableView.delegate = self
        nvsBasketFolderView.folderTableView.dataSource = self
        nvsBasketFolderView.folderTableView.register(FolderTableViewCell.self, forCellReuseIdentifier: FolderTableViewCell.identifier)
        nvsBasketFolderView.folderTableView.rowHeight = 60
        nvsBasketFolderView.folderTableView.separatorStyle = .none
    }
}

extension NVSBasketFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row > 1 {
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, success in
                guard let self else {
                    success(false)
                    return
                }
                let folder = folder[indexPath.row]
                realmRepository.deleteItem(folder)
                nvsBasketFolderView.folderTableView.deleteRows(at: [indexPath], with: .automatic)
                success(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.identifier, for: indexPath) as? FolderTableViewCell else { return UITableViewCell() }
        let folder = self.folder[indexPath.row]
        cell.configureContent(title: folder.name, option: folder.option, count: folder.detail.count)
        return cell
    }
}
