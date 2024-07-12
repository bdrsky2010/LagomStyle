//
//  MainViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import RealmSwift
import SnapKit

final class NVSSearchViewController: BaseViewController {
    
    private let nvsSearchView: NVSSearchView
    private let viewModel: NVSSearchViewModel
    
    override init() {
        self.nvsSearchView = NVSSearchView()
        self.viewModel = NVSSearchViewModel()
        super.init()
    }
    
    override func loadView() {
        view = nvsSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoadTrigger.value = ()
        viewModel.inputTableViewReloadTrigger.value = ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    private func bindData() {
        viewModel.outputDidConfigureViewTrigger.bind { [weak self] _ in
            guard let self else { return }
            configureTextField()
            configutrRemoveAllButton()
            configureTableView()
        }
        
        viewModel.outputDidChangeNavigationTitle.bind { [weak self] title in
            guard let self else { return }
            navigationItem.title = title
        }
        
        viewModel.outputDidChangeRecentSearchList.bind { [weak self] list in
            guard let self else { return }
            let isHidden = list.isEmpty
            nvsSearchView.recentSearchTableViewTitleLabel.isHidden = isHidden
            nvsSearchView.removeAllQueriesButton.isHidden = isHidden
            nvsSearchView.recentSearchTableView.isHidden = isHidden
            nvsSearchView.emptyView.isHidden = !isHidden
            if !isHidden { nvsSearchView.recentSearchTableView.reloadData() }
        }
        
        viewModel.outputDidPushSearchResultViewTrigger.bind { [weak self] query in
            guard let self else { return }
            let nvsSearchResultViewController = NVSSearchResultViewController(query: query)
            navigationController?.pushViewController(nvsSearchResultViewController, animated: true)
        }
    }
    
    private func configureTextField() {
        nvsSearchView.productSearchTextField.delegate = self
    }
    
    private func configutrRemoveAllButton() {
        nvsSearchView.removeAllQueriesButton.addTarget(self, action: #selector(removeAllButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func removeAllButtonClicked() {
        viewModel.inputClickedRemoveAllButton.value = ()
        viewModel.inputTableViewReloadTrigger.value = ()
    }
    
    private func configureTableView() {
        nvsSearchView.recentSearchTableView.delegate = self
        nvsSearchView.recentSearchTableView.dataSource = self
        nvsSearchView.recentSearchTableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        nvsSearchView.recentSearchTableView.separatorStyle = .none
        nvsSearchView.recentSearchTableView.rowHeight = 32
    }
}

extension NVSSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        viewModel.inputTextFieldShouldReturn.value = text
        viewModel.inputTableViewReloadTrigger.value = ()
        viewModel.inputPushSearchResultViewTrigger.value = text
        textField.text = nil
        return true
    }
}

extension NVSSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = viewModel.outputDidChangeRecentSearchList.value[indexPath.row]
        let nvsSearchResultViewController = NVSSearchResultViewController(query: query)
        
        navigationController?.pushViewController(nvsSearchResultViewController, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputDidChangeRecentSearchList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as? RecentSearchTableViewCell else { return UITableViewCell() }
        
        let row = indexPath.row
        let query = viewModel.outputDidChangeRecentSearchList.value[row]
        
        cell.configureContent(query: query)
        cell.removeButton.tag = row
        cell.removeButton.addTarget(self, action: #selector(removeButtonClicked), for: .touchUpInside)
        return cell
    }
    
    @objc
    private func removeButtonClicked(sender: UIButton) {
        let index = sender.tag
        viewModel.inputClickedRemoveButton.value = index
        viewModel.inputTableViewReloadTrigger.value = ()
    }
}
