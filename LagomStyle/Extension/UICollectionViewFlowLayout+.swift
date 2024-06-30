//
//  UICollectionViewFlowLayout+.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/30/24.
//

import UIKit

extension UICollectionViewFlowLayout {
    static func layoutWith2X2() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 16
        let cellSpacing: CGFloat = 16
        
        if let screenWidth = UIView.screenSize?.width {
            let itemWidth = screenWidth - (sectionSpacing * 2) - cellSpacing
            layout.itemSize = CGSize(width: itemWidth / 2, height: itemWidth / 1.2)
            layout.minimumLineSpacing = sectionSpacing
            layout.minimumInteritemSpacing = cellSpacing
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        }
        return layout
    }
}
