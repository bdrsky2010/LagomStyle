//
//  ConfigureViewProtocol.swift
//  LagomStyle
//
//  Created by Minjae Kim on 6/13/24.
//

import Foundation

// MARK: 공통으로 사용되는 View Configure 메서드 프로토콜
@objc
protocol ConfigureViewProtocol {
    @objc optional func configureView()
    @objc optional func configureNavigation()
    @objc optional func configureHierarchy()
    @objc optional func configureLayout()
    @objc optional func configureUI()
    @objc optional func configureContent()
}
