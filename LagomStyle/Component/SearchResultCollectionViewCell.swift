//
//  SearchResultCollectionViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

final class SearchResultCollectionViewCell: UICollectionViewCell, ConfigureViewProtocol {
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var delegate: NVSSearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func configureView() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureContent() {
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
