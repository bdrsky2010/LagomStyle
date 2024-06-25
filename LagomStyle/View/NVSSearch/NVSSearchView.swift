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
    
    private let divider = Divider(backgroundColor: LagomStyle.Color.lagomLightGray)
    
    let productSearchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: LagomStyle.phrase.searchViewPlaceholder, attributes: [NSAttributedString.Key.font: LagomStyle.Font.regular16, NSAttributedString.Key.foregroundColor: LagomStyle.Color.lagomGray])
        textField.returnKeyType = .search
        return textField
    }()
    
    
    let recentSearchTableViewTitleLabel = UILabel.blackBlack14(text: LagomStyle.phrase.searchViewRecentSearch)
    
    let removeAllQueriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.attributedTitle = AttributedString(
            NSAttributedString(string: LagomStyle.phrase.searchViewRemoveAll,
                               attributes: [NSAttributedString.Key.font: LagomStyle.Font.regular13,
                                            NSAttributedString.Key.foregroundColor: LagomStyle.Color.lagomPrimaryColor]))
        button.configuration?.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return button
    }()
    
    let recentSearchTableView = UITableView()
    let emptyView = EmptyResultView(text: LagomStyle.phrase.searchViewNoRecentSearch)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(productSearchBarView)
        productSearchBarView.addSubview(productSearchBarImage)
        productSearchBarView.addSubview(productSearchTextField)
        
        addSubview(divider)
        addSubview(recentSearchTableViewTitleLabel)
        addSubview(removeAllQueriesButton)
        addSubview(recentSearchTableView)
        addSubview(emptyView)
    }
    
    override func configureLayout() {
        productSearchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
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
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        removeAllQueriesButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchTableViewTitleLabel.snp.centerY)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchTableViewTitleLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
