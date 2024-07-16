//
//  NVSBasketFolderViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import UIKit

import RealmSwift

final class NVSBasketFolderViewController: BaseViewController {
    
    private let nvsBasketFolderView: NVSBasketFolderView
    private let viewModel: NVSBasketFolderViewModel
    private let realmRepository: RealmRepository
    
    private var folder: Results<Folder>!
    
    override init() {
        self.nvsBasketFolderView = NVSBasketFolderView()
        self.viewModel = NVSBasketFolderViewModel()
        self.realmRepository = RealmRepository()
        super.init()
    }
    
    override func loadView() {
        view = nvsBasketFolderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoad.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppear.value = ()
    }
    
    private func bindData() {
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            configureTableView()
        }
        
        viewModel.outputDidConfigureNavigation.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            navigationItem.title = tuple.title
            
            let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: tuple.image), style: .plain, target: self, action: #selector(plusButtonClicked))
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        viewModel.outputDidTableViewReloadData.bind { [weak self] _ in
            guard let self else { return }
            nvsBasketFolderView.folderTableView.reloadData()
        }
        
        viewModel.outputDidTableViewReloadRows.bind { [weak self] indexPaths in
            guard let self else { return }
            nvsBasketFolderView.folderTableView.reloadRows(at: indexPaths, with: .automatic)
        }
        
        viewModel.outputDidTableViewDeleteRows.bind { [weak self] indexPaths in
            guard let self else { return }
            nvsBasketFolderView.folderTableView.deleteRows(at: indexPaths, with: .automatic)
            viewModel.inputTableViewReloadData.value = ()
        }
        
        viewModel.outputDidPresentAddFolderView.bind { [weak self] _ in
            guard let self else { return }
            let addBasketFolderViewController = AddBasketFolderViewController()
            addBasketFolderViewController.onAddButtonClicked = { [weak self] in
                guard let self else { return }
                viewModel.inputTableViewReloadData.value = ()
            }
            let navigationController = UINavigationController(rootViewController: addBasketFolderViewController)
            present(navigationController, animated: true)
        }
        
        viewModel.outputDidPushNavigation.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            let nvsBasketViewController = NVSBasketViewController(folder: tuple.folder)
            nvsBasketViewController.onChangeFolder = { [weak self] in
                guard let self else { return }
                viewModel.inputTableViewReloadData.value = ()
            }
            navigationController?.pushViewController(nvsBasketViewController, animated: true)
            viewModel.inputTableViewReloadRows.value = [tuple.indexPath]
        }
    }
    
    @objc
    private func plusButtonClicked() {
        viewModel.inputPlusButtonClicked.value = ()
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
                viewModel.inputDeleteFolder.value = indexPath
                success(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.inputDidSelectRowAt.value = indexPath
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputDidFetchFolderData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.identifier, for: indexPath) as? FolderTableViewCell else { return UITableViewCell() }
        let folder = viewModel.outputDidFetchFolderData.value[indexPath.row]
        
        if indexPath.row == 0 {
            cell.configureContent(title: folder.name, option: folder.option, count: viewModel.outputDidFetchBasketData.value.count)
        } else {
            cell.configureContent(title: folder.name, option: folder.option, count: folder.detail.count)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            let modify = UIAction(title: "수정", image: UIImage(systemName: "square.and.pencil")) { _ in
                print("수정하기")
            }
            let note = UIAction(title: "메모", image: UIImage(systemName: "list.bullet.clipboard")) { _ in
                print("메모하기")
            }
            let delete = UIAction(title: "삭제", image: UIImage(systemName: "trash")) { _ in
                print("메모하기")
            }
            
            return UIMenu(children: [modify, note, delete])
        })
    }
}
