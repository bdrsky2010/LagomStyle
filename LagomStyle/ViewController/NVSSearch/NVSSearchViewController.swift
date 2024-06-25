//
//  MainViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class NVSSearchViewController: BaseViewController {
    
    private let nvsSearchView = NVSSearchView()
    
    private var recentSearchQueries: [String] {
        get {
            guard let queries =  UserDefaultsHelper.recentSearchQueries else {
                
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
            
            return queries
        }
        
        set {
            if !newValue.isEmpty {
                UserDefaultsHelper.recentSearchQueries = newValue
            } else {
                UserDefaultsHelper.removeUserDefaults(forKey: LagomStyle.UserDefaultsKey.recentSearchQueries)
            }
            nvsSearchView.recentSearchTableView.reloadData()
        }
    }
    
    override func loadView() {
        view = nvsSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func configureView() {
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureTextField()
        configutrRemoveAllButton()
        configureTableView()
    }
    
    override func configureNavigation() {
        guard let nickname = UserDefaultsHelper.nickname else { return }
        navigationItem.title = nickname + LagomStyle.phrase.searchViewNavigationTitle
    }
    
    private func configureTextField() {
        nvsSearchView.productSearchTextField.delegate = self
    }
    
    private func configutrRemoveAllButton() {
        nvsSearchView.removeAllQueriesButton.addTarget(self, action: #selector(removeAllButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func removeAllButtonClicked() {
        recentSearchQueries = []
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
        
        var queries = recentSearchQueries
        
        if !queries.contains(text) { // 최근 검색어에 새로 검색한 키워드가 없다면
            queries.insert(text, at: 0)
            recentSearchQueries = queries
            
            if queries.count > 10 {
                for i in (10..<queries.count).reversed() {
                    removeQuery(row: i)
                }
            }
        } else {
            for i in 0..<queries.count {
                if queries[i] == text {
                    queries.remove(at: i)
                    break
                }
            }
            queries.insert(text, at: 0)
            recentSearchQueries = queries
        }
        textField.text = nil
        return true
    }
}

extension NVSSearchViewController: UITableViewDelegate, UITableViewDataSource, RecentSearchQueryDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nvsSearchResultViewController = NVSSearchResultViewController()
        nvsSearchResultViewController.query = recentSearchQueries[indexPath.row]
        
        navigationController?.pushViewController(nvsSearchResultViewController, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchQueries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as? RecentSearchTableViewCell else { return UITableViewCell() }
        
        let row = indexPath.row
        
        cell.row = row
        cell.configureContent(query: recentSearchQueries[row])
        cell.delegate = self
        return cell
    }
    
    func removeQuery(row: Int) {
        var removeQueries = recentSearchQueries
        removeQueries.remove(at: row)
        
        recentSearchQueries = removeQueries
    }
}
