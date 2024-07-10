//
//  AddBasketFolderView.swift
//  LagomStyle
//
//  Created by Minjae Kim on 7/9/24.
//

import UIKit

import SnapKit

final class AddBasketFolderView: BaseView {
    
    private let titleHeaderLabel = UILabel.blackBlack16(text: "이름")
    private let optionHeaderLabel = UILabel.blackBlack16(text: "설명")
    private let titleUnderBar = Divider(backgroundColor: LagomStyle.AssetColor.lagomLightGray)
    private let optionUnderBar = Divider(backgroundColor: LagomStyle.AssetColor.lagomLightGray)
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "이름을 입력해주세요",
            attributes: [NSAttributedString.Key.font: LagomStyle.SystemFont.bold16,
                         NSAttributedString.Key.foregroundColor: LagomStyle.AssetColor.lagomLightGray])
        textField.borderStyle = .none
        return textField
    }()
    
    let optionTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "설명을 입력해주세요",
            attributes: [NSAttributedString.Key.font: LagomStyle.SystemFont.bold16,
                         NSAttributedString.Key.foregroundColor: LagomStyle.AssetColor.lagomLightGray])
        textField.borderStyle = .none
        return textField
    }()
    
    let addButton = PrimaryColorRoundedButton(title: "저장")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        addSubview(titleHeaderLabel)
        addSubview(titleTextField)
        addSubview(titleUnderBar)
        addSubview(optionHeaderLabel)
        addSubview(optionTextField)
        addSubview(optionUnderBar)
        addSubview(addButton)
    }
    
    override func configureLayout() {
        titleHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleHeaderLabel.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        titleUnderBar.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        optionHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(titleUnderBar.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        optionTextField.snp.makeConstraints { make in
            make.top.equalTo(optionHeaderLabel.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        optionUnderBar.snp.makeConstraints { make in
            make.top.equalTo(optionTextField.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
}
