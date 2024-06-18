//
//  SettingViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

import SnapKit

final class SettingViewController: UIViewController, ConfigureViewProtocol {
    
    private let settingTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTableView.reloadData()
    }
    
    func configureView() {
        view.backgroundColor = LagomStyle.Color.lagomWhite
        
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureTableView()
    }
    
    func configureNavigation() {
        navigationItem.title = LagomStyle.phrase.settingViewNavigationTitle
    }
    
    func configureHierarchy() {
        view.addSubview(settingTableView)
    }
    
    func configureLayout() {
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.separatorStyle = .none
        settingTableView.register(SettingTableViewProfileCell.self, forCellReuseIdentifier: SettingTableViewProfileCell.identifier)
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        if index == 0 {
            let profileSetupViewController = ProfileSetupViewController()
            profileSetupViewController.pfSetupType = .edit
            navigationController?.pushViewController(profileSetupViewController, animated: true)
        }
        if index == 5 {
            presentAlert(type: .twoButton, title: LagomStyle.phrase.withDrawAlertTitle,
                         message: LagomStyle.phrase.withDrawAlertMessage) { [weak self] in
                guard let self else { return }
                UserDefaultsHelper.removeAllUserDefaults()
                
                let onboardingViewController = OnboardingViewController()
                changeRootViewController(rootViewController: onboardingViewController)
            }
        }
        
        settingTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LagomStyle.phrase.settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if index == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewProfileCell.identifier, for: indexPath) as? SettingTableViewProfileCell else { return UITableViewCell() }
            cell.configureContent()
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        if index == 1 {
            let likeProductsCount = UserDefaultsHelper.likeProducts?.count
            cell.configureContent(option: LagomStyle.phrase.settingOptions[index], likeProductsCount: likeProductsCount ?? 0)
        } else {
            cell.configureContent(option: LagomStyle.phrase.settingOptions[index])
        }
        return cell
    }
    
    
}
