//
//  NVSProductDetailView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/25/24.
//

import UIKit
import WebKit

import SnapKit

final class NVSProductDetailView: BaseView {
    let webView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        addSubview(webView)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
