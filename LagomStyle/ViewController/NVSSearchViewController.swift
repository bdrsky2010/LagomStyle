//
//  MainViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class NVSSearchViewController: UIViewController, ConfigureViewProtocol {
    
    private let productSearchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = LagomStyle.Color.lagomLightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let productSearchBarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: LagomStyle.SystemImage.magnifyingglass)
        imageView.tintColor = LagomStyle.Color.lagomGray
        return imageView
    }()
    
    private let productSearchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: LagomStyle.phrase.searchViewPlaceholder, attributes: [NSAttributedString.Key.font: LagomStyle.Font.regular16, NSAttributedString.Key.foregroundColor: LagomStyle.Color.lagomGray])
        textField.returnKeyType = .search
        return textField
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = LagomStyle.Color.lagomLightGray
        return view
    }()
    
    private let recentSearchTableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.black14
        label.text = LagomStyle.phrase.searchViewRecentSearch
        label.textColor = LagomStyle.Color.lagomBlack
        return label
    }()
    
    private let removeAllQueriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.attributedTitle = AttributedString(
            NSAttributedString(string: LagomStyle.phrase.searchViewRemoveAll,
                               attributes: [NSAttributedString.Key.font: LagomStyle.Font.regular13,
                                            NSAttributedString.Key.foregroundColor: LagomStyle.Color.lagomPrimaryColor]))
        button.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return button
    }()
    
    private let recentSearchTableView = UITableView()
    
    private let emptyView = UIView()
    
    private let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: LagomStyle.Image.empty.imageName)
        return imageView
    }()
    
    private let emptyText: UILabel = {
        let label = UILabel()
        label.font = LagomStyle.Font.black16
        label.textColor = LagomStyle.Color.lagomBlack
        label.text = LagomStyle.phrase.searchViewNoRecentSearch
        return label
    }()
    
    private var recentSearchQueries: [String] {
        get {
            guard let queries =  UserDefaultsHelper.getUserDefaults(forKey: LagomStyle.UserDefaultsKey.recentSearchQueries) as? [String] else {
                
                recentSearchTableViewTitleLabel.isHidden = true
                removeAllQueriesButton.isHidden = true
                recentSearchTableView.isHidden = true
                
                emptyView.isHidden = false
                
                return []
            }
            
            recentSearchTableViewTitleLabel.isHidden = false
            removeAllQueriesButton.isHidden = false
            recentSearchTableView.isHidden = false
            
            emptyView.isHidden = true
            
            return queries
        }
        
        set {
            if !newValue.isEmpty {
                UserDefaultsHelper.setUserDefaults(value: newValue, forKey: LagomStyle.UserDefaultsKey.recentSearchQueries)
            } else {
                UserDefaultsHelper.removeUsetDefaults(forKey: LagomStyle.UserDefaultsKey.recentSearchQueries)
            }
            recentSearchTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureTextField()
        configutrRemoveAllButton()
        configureTableView()
    }
    
    func configureNavigation() {
        guard let nickname = UserDefaultsHelper.getUserDefaults(forKey: LagomStyle.UserDefaultsKey.nickname) as? String else { return }
        navigationItem.title = nickname + LagomStyle.phrase.searchViewNavigationTitle
    }
    
    func configureHierarchy() {
        
        view.addSubview(productSearchBarView)
        productSearchBarView.addSubview(productSearchBarImage)
        productSearchBarView.addSubview(productSearchTextField)
        
        view.addSubview(divider)
        view.addSubview(recentSearchTableViewTitleLabel)
        view.addSubview(removeAllQueriesButton)
        view.addSubview(recentSearchTableView)
        
        view.addSubview(emptyView)
        emptyView.addSubview(emptyImage)
        emptyView.addSubview(emptyText)
    }
    
    func configureLayout() {
        
        productSearchBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        productSearchBarImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        productSearchTextField.snp.makeConstraints { make in
            make.leading.equalTo(productSearchBarImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(productSearchBarView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        recentSearchTableViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        removeAllQueriesButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchTableViewTitleLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchTableViewTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(emptyView.snp.height).multipliedBy(0.5)
        }
        
        emptyText.snp.makeConstraints { make in
            make.top.equalTo(emptyImage.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureTextField() {
        productSearchTextField.delegate = self
    }
    
    private func configutrRemoveAllButton() {
        removeAllQueriesButton.addTarget(self, action: #selector(removeAllButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func removeAllButtonClicked() {
        recentSearchQueries = []
    }
    
    private func configureTableView() {
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        recentSearchTableView.register(RecentSearchTableViewCell.self,
                                       forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        
        recentSearchTableView.separatorStyle = .none
        recentSearchTableView.rowHeight = 32
    }
}

extension NVSSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        
        var queries = recentSearchQueries
        queries.insert(text, at: 0)
        
        recentSearchQueries = queries
        
        if queries.count > 10 {
            for i in (10..<queries.count).reversed() {
                removeQuery(row: i)
            }
        }
        
        textField.text = nil
        
        let nvsSearchResultViewController = NVSSearchResultViewController()
        navigationController?.pushViewController(nvsSearchResultViewController, animated: true)
        
        return true
    }
}

extension NVSSearchViewController: UITableViewDelegate, UITableViewDataSource, RecentSearchQueryDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nvsSearchResultViewController = NVSSearchResultViewController()
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