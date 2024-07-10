//
//  NVSBasketView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit

import SnapKit

final class NVSBasketView: BaseView {
    let nvsBasketCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.layoutWith2X2())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(nvsBasketCollectionView)
    }
    
    override func configureLayout() {
        nvsBasketCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
