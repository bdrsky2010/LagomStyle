//
//  RecentSearchTableViewCell.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/17/24.
//

import UIKit

import SnapKit

class RecentSearchTableViewCell: UITableViewCell, ConfigureViewProtocol {
    
    private let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: LagomStyle.SystemImage.clock)
        imageView.tintColor = LagomStyle.Color.lagomBlack
        return imageView
    }()
    
    private let queryLabel = UILabel.blackRegular13()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: LagomStyle.SystemImage.xmark)
        button.configuration?.baseForegroundColor = LagomStyle.Color.lagomBlack
        return button
    }()
    
    var row: Int?
    var delegate: RecentSearchQueryDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    func configureView() {
        configureHierarchy()
        configureLayout()
        configureButton()
    }
    
    func configureHierarchy() {
        contentView.addSubview(clockImage)
        contentView.addSubview(removeButton)
        contentView.addSubview(queryLabel)
    }
    
    func configureLayout() {
        clockImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        queryLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockImage.snp.trailing).offset(16)
            make.trailing.equalTo(removeButton.snp.leading).offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureButton() {
        removeButton.addTarget(self, action: #selector(removeButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func removeButtonClicked() {
        guard let row else { return }
        delegate?.removeQuery(row: row)
    }
    
    func configureContent(query: String) {
        queryLabel.text = query
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
