//
//  AddOrMoveBasketFolderView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/9/24.
//

import UIKit

import SnapKit

final class AddOrMoveBasketFolderView: BaseView {
    let folderTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
    }
    
    override func configureHierarchy() {
        addSubview(folderTableView)
    }
    
    override func configureLayout() {
        folderTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
