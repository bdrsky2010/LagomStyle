//
//  ProductsCollectionView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/18/24.
//

import UIKit

final class ProductsCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 16
        let cellSpacing: CGFloat = 16
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let screenWidth = windowScene.screen.bounds.width
            let itemWidth = screenWidth - (sectionSpacing * 2) - cellSpacing
            layout.itemSize = CGSize(width: itemWidth / 2, height: itemWidth / 1.2)
            layout.minimumLineSpacing = sectionSpacing
            layout.minimumInteritemSpacing = cellSpacing
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        }
        
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
