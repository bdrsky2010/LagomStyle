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
//            configureTableView()
            configureCollectionView()
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
            nvsSearchView.recentSearchCollectionView.isHidden = isHidden
            nvsSearchView.emptyView.isHidden = !isHidden
            if !isHidden { nvsSearchView.recentSearchCollectionView.reloadData() }
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
    
    private func configureCollectionView() {
        nvsSearchView.recentSearchCollectionView.delegate = self
        nvsSearchView.recentSearchCollectionView.dataSource = self
        nvsSearchView.recentSearchCollectionView.register(
            CapsuleCollectionViewCell.self,
            forCellWithReuseIdentifier: CapsuleCollectionViewCell.identifier
        )
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

extension NVSSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let query = viewModel.outputDidChangeRecentSearchList.value[indexPath.row]
        let nvsSearchResultViewController = NVSSearchResultViewController(query: query)
        
        navigationController?.pushViewController(nvsSearchResultViewController, animated: true)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputDidChangeRecentSearchList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CapsuleCollectionViewCell.identifier, for: indexPath) as? CapsuleCollectionViewCell else { return UICollectionViewCell() }
        
        let row = indexPath.row
        let query = viewModel.outputDidChangeRecentSearchList.value[row]
        
        cell.configureContent(text: query)
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
