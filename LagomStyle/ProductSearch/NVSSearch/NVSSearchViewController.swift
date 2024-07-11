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
    
    private let nvsSearchView = NVSSearchView()
    private let realmRepository = RealmRepository()
    
    private var recentSearchKeyword = Map<String, Date>()
    private var recentSearchQueriesArray: [String] {
        get {
            guard recentSearchKeyword.count != 0 else {
                nvsSearchView.recentSearchTableViewTitleLabel.isHidden = true
                nvsSearchView.removeAllQueriesButton.isHidden = true
                nvsSearchView.recentSearchTableView.isHidden = true
                nvsSearchView.emptyView.isHidden = false
                return []
            }
            nvsSearchView.recentSearchTableViewTitleLabel.isHidden = false
            nvsSearchView.removeAllQueriesButton.isHidden = false
            nvsSearchView.recentSearchTableView.isHidden = false
            nvsSearchView.emptyView.isHidden = true
            return recentSearchKeyword.sorted(by: { $0.value > $1.value }).map { $0.key }
        }
    }
    
    override init() {
        super.init()
        
    }
    
    override func loadView() {
        view = nvsSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecentSearch()
        configureTextField()
        configutrRemoveAllButton()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func configureNavigation() {
        guard let nickname = realmRepository.fetchItem(of: UserTable.self).first?.nickname else { return }
        navigationItem.title = nickname + LagomStyle.Phrase.searchViewNavigationTitle
    }
    
    private func configureRecentSearch() {
        if let user = realmRepository.fetchItem(of: UserTable.self).first {
            recentSearchKeyword = user.recentSearchKeyword
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
        realmRepository.updateItem {
            recentSearchKeyword.removeAll()
        }
        nvsSearchView.recentSearchTableView.reloadData()
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
        
        let nvsSearchResultViewController = NVSSearchResultViewController()
        nvsSearchResultViewController.query = text
        
        navigationController?.pushViewController(nvsSearchResultViewController, animated: true)
        realmRepository.updateItem {
            recentSearchKeyword.setValue(Date(), forKey: text)
        }
        nvsSearchView.recentSearchTableView.reloadData()
        
        textField.text = nil
        return true
    }
}

extension NVSSearchViewController: UITableViewDelegate, UITableViewDataSource, RecentSearchQueryDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nvsSearchResultViewController = NVSSearchResultViewController()
        nvsSearchResultViewController.query = recentSearchQueriesArray[indexPath.row]
        
        navigationController?.pushViewController(nvsSearchResultViewController, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchQueriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as? RecentSearchTableViewCell else { return UITableViewCell() }
        
        let row = indexPath.row
        
        cell.row = row
        cell.configureContent(query: recentSearchQueriesArray[row])
        cell.delegate = self
        return cell
    }
    
    func removeQuery(row: Int) {
        realmRepository.updateItem {
            recentSearchKeyword.removeObject(for: recentSearchQueriesArray[row])
        }
        nvsSearchView.recentSearchTableView.reloadData()
    }
}
