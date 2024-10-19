//
//  NVSSearchView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

import SnapKit

final class NVSSearchView: BaseView {
    
    private let productSearchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = LagomStyle.AssetColor.lagomLightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let divider = Divider(backgroundColor: LagomStyle.AssetColor.lagomLightGray)
    
    let productSearchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: LagomStyle.Phrase.searchViewPlaceholder,
            attributes: [
                NSAttributedString.Key.font: LagomStyle.SystemFont.regular16,
                NSAttributedString.Key.foregroundColor: LagomStyle.AssetColor.lagomGray
            ]
        )
        textField.returnKeyType = .search
        return textField
    }()
    
    
    let recentSearchTableViewTitleLabel = UILabel.blackBlack16(text: LagomStyle.Phrase.searchViewRecentSearch)
    
    let removeAllQueriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.attributedTitle = AttributedString(
            NSAttributedString(
                string: LagomStyle.Phrase.searchViewRemoveAll,
                attributes: [
                    NSAttributedString.Key.font: LagomStyle.SystemFont.regular13,
                    NSAttributedString.Key.foregroundColor: LagomStyle.AssetColor.lagomPrimaryColor
                ]
            )
        )
        button.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return button
    }()
    
//    let recentSearchTableView = UITableView()
    let recentSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let emptyView = EmptyResultView(text: LagomStyle.Phrase.searchViewNoRecentSearch)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(productSearchBarView)
        productSearchBarView.addSubview(productSearchTextField)
        
        addSubview(divider)
        addSubview(recentSearchTableViewTitleLabel)
        addSubview(removeAllQueriesButton)
        addSubview(recentSearchCollectionView)
        addSubview(emptyView)
    }
    
    override func configureLayout() {
        productSearchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        productSearchTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(productSearchBarView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        recentSearchTableViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(divider).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        removeAllQueriesButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchTableViewTitleLabel.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
//        recentSearchTableView.snp.makeConstraints { make in
//            make.top.equalTo(recentSearchTableViewTitleLabel.snp.bottom).offset(16)
//            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
//        }
        
        recentSearchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchTableViewTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension NVSSearchView {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(6)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
