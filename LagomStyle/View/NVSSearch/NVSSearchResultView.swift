//
//  NVSSearchResultView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

import SnapKit

final class NVSSearchResultView: BaseView {
    let accuracyFilteringButton = CapsuleTapActionButton(title: NVSSSort.sim.segmentedTitle, tag: 0)
    let dateFilteringButton = CapsuleTapActionButton(title: NVSSSort.date.segmentedTitle, tag: 1)
    let priceAscFilteringButton = CapsuleTapActionButton(title: NVSSSort.dsc.segmentedTitle, tag: 2)
    let priceDscFilteringButton = CapsuleTapActionButton(title: NVSSSort.asc.segmentedTitle, tag: 3)
    
    let searchResultCountLabel = UILabel.primaryBold13()
    let searchResultCollectionView = ProductsCollectionView()
    let emptyView = EmptyResultView(text: LagomStyle.phrase.searchEmptyResult)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(searchResultCountLabel)
        addSubview(accuracyFilteringButton)
        addSubview(dateFilteringButton)
        addSubview(priceAscFilteringButton)
        addSubview(priceDscFilteringButton)
        addSubview(searchResultCollectionView)
        addSubview(emptyView)
    }
    
    override func configureLayout() {
        searchResultCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        accuracyFilteringButton.snp.makeConstraints { make in
            make.top.equalTo(searchResultCountLabel.snp.bottom).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        dateFilteringButton.snp.makeConstraints { make in
            make.leading.equalTo(accuracyFilteringButton.snp.trailing).offset(8)
            make.centerY.equalTo(accuracyFilteringButton)
        }
        
        priceAscFilteringButton.snp.makeConstraints { make in
            make.leading.equalTo(dateFilteringButton.snp.trailing).offset(8)
            make.centerY.equalTo(accuracyFilteringButton)
        }
        
        priceDscFilteringButton.snp.makeConstraints { make in
            make.leading.equalTo(priceAscFilteringButton.snp.trailing).offset(8)
            make.centerY.equalTo(accuracyFilteringButton)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(accuracyFilteringButton.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(accuracyFilteringButton.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
