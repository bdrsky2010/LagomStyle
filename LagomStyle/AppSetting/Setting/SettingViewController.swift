//
//  SettingViewController.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/16/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let settingView: SettingView
    private let viewModel: SettingViewModel
    private let realmRepository: RealmRepository
    
    override init() {
        self.settingView = SettingView()
        self.viewModel = SettingViewModel()
        self.realmRepository = RealmRepository()
        super.init()
    }
    
    override func loadView() {
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewModel.inputViewDidLoad.value = ()
    }
    
    private func bindData() {
        viewModel.outputDidConfigureView.bind { [weak self] _ in
            guard let self else { return }
            configureTableView()
        }
        
        viewModel.outputDidConfigureNavigationBarTitle.bind { [weak self] title in
            guard let self else { return }
            navigationItem.title = title
        }
        
        viewModel.outputDidTableViewReloadData.bind { [weak self] _ in
            guard let self else { return }
            settingView.settingTableView.reloadData()
        }
        
        viewModel.outputDidTableViewReloadRows.bind { [weak self] indexPaths in
            guard let self else { return }
            settingView.settingTableView.reloadRows(at: indexPaths, with: .automatic)
        }
        
        viewModel.outputDidPushNavigation.bind { [weak self] router in
            guard let self, let router else { return }
            var viewController: UIViewController
            switch router {
            case .profileEdit:
                viewController = ProfileSetupViewController(pfSetupOption: .edit)
            case .basketFolder:
                viewController = NVSBasketFolderViewController()
            }
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        viewModel.outputDidPresentWithdrawalAlert.bind { [weak self] tuple in
            guard let self, let tuple else { return }
            presentAlert(option: .twoButton,
                         title: tuple.title,
                         message: tuple.message,
                         checkAlertTitle: "확인") { [weak self] _ in
                guard let self else { return }
                viewModel.inputDeleteDatabase.value = ()
                viewModel.inputChangeRootView.value = ()
            }
        }
        
        viewModel.outputDidChangeRootView.bind { [weak self] _ in
            guard let self else { return }
            let onboardingViewController = OnboardingViewController()
            changeRootViewController(rootViewController: onboardingViewController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputTableViewReloadData.value = ()
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
            viewModel.inputPushNavigation.value = .profileEdit
        }
        if index == 1 {
            viewModel.inputPushNavigation.value = .basketFolder
        }
        if index == 5 {
            viewModel.inputDidWithdrawal.value = ()
        }
        
        viewModel.inputTableViewReloadRows.value = [indexPath]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getOptionPhraseCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.getTableViewRowHeight(row: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if index == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewProfileCell.identifier, for: indexPath) as? SettingTableViewProfileCell else { return UITableViewCell() }
            if let user = viewModel.outputDidUserDataFetch.value {
                cell.configureContent(user: user)
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        let optionPhrase = viewModel.getOptionPhrase(index: index)
        let count = viewModel.outputDidBasketDataFetch.value
        cell.configureContent(option: optionPhrase, likeProductsCount: index == 1 ? count : nil)
        return cell
    }
    
    
}
