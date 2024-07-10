//
//  NVSBasketFolderView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/8/24.
//

import UIKit

import SnapKit

final class NVSBasketFolderView: BaseView {
    let folderTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
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
