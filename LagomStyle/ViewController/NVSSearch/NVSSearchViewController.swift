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
    
    private var recentSearchQueries: [String: Date] {
        get {
            guard let queries =  UserDefaultsHelper.recentSearchQueries else {
                
                nvsSearchView.recentSearchTableViewTitleLabel.isHidden = true
                nvsSearchView.removeAllQueriesButton.isHidden = true
                nvsSearchView.recentSearchTableView.isHidden = true
                
                nvsSearchView.emptyView.isHidden = false
                
                return [:]
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
    
    private var recentSearchQueriesArray: [String] {
        return recentSearchQueries.sorted(by: { $0.value > $1.value }).map { $0.key }
    }
    
    override func loadView() {
        view = nvsSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTextField()
        configutrRemoveAllButton()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func configureNavigation() {
        guard let nickname = UserDefaultsHelper.nickname else { return }
        navigationItem.title = nickname + LagomStyle.Phrase.searchViewNavigationTitle
    }
    
    private func configureTextField() {
        nvsSearchView.productSearchTextField.delegate = self
    }
    
    private func configutrRemoveAllButton() {
        nvsSearchView.removeAllQueriesButton.addTarget(self, action: #selector(removeAllButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func removeAllButtonClicked() {
        recentSearchQueries = [:]
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
        
        recentSearchQueries[text] = Date()
        
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
        return recentSearchQueries.count
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
        recentSearchQueries[recentSearchQueriesArray[row]] = nil
    }
}
