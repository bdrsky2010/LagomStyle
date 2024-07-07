//
//  SettingViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let settingView = SettingView()
    private let userTableRepository = UserTableRepository()
    
    override func loadView() {
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingView.settingTableView.reloadData()
    }
    
    override func configureNavigation() {
        navigationItem.title = LagomStyle.Phrase.settingViewNavigationTitle
    }
    
    private func configureTableView() {
        settingView.settingTableView.delegate = self
        settingView.settingTableView.dataSource = self
        settingView.settingTableView.separatorStyle = .none
        settingView.settingTableView.register(SettingTableViewProfileCell.self, forCellReuseIdentifier: SettingTableViewProfileCell.identifier)
        settingView.settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
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
        if index == 1 {
            let nvsBasketViewController = NVSBasketViewController()
            navigationController?.pushViewController(nvsBasketViewController, animated: true)
        }
        if index == 5 {
            presentAlert(option: .twoButton, 
                         title: LagomStyle.Phrase.withDrawAlertTitle,
                         message: LagomStyle.Phrase.withDrawAlertMessage,
                         checkAlertTitle: "확인") { [weak self] _ in
                guard let self else { return }
//                UserDefaultsHelper.removeAllUserDefaults()
                if let user = userTableRepository.fetchUser().first {
                    userTableRepository.deleteItem(user)
                }
                
                let onboardingViewController = OnboardingViewController()
                changeRootViewController(rootViewController: onboardingViewController)
            }
        }
        
        settingView.settingTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LagomStyle.Phrase.settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if index == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewProfileCell.identifier, for: indexPath) as? SettingTableViewProfileCell else { return UITableViewCell() }
//            cell.configureContent()
            if let user = userTableRepository.fetchUser().first {
                cell.configureContent(user: user)
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        if index == 1 {
            let likeProductsCount = UserDefaultsHelper.likeProducts?.count
            cell.configureContent(option: LagomStyle.Phrase.settingOptions[index], likeProductsCount: likeProductsCount ?? 0)
        } else {
            cell.configureContent(option: LagomStyle.Phrase.settingOptions[index])
        }
        return cell
    }
    
    
}
