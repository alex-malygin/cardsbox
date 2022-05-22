//
//  BaseTextFieldView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/22/22.
//

import UIKit

final class BaseTextFieldView: ReusableView {
    private var textFiled: UITextField!
    private var separatorView: UIView!
    
    override func setupView() {
        setupTextFieldView()
        setupTextFieldViewConstraints()
    }
}

extension BaseTextFieldView {
    private func setupTextFieldView() {
        backgroundColor = .clear
        
        textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.borderStyle = .none
        textFiled.placeholder = "test"
        addSubview(textFiled)
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .gray.withAlphaComponent(0.2)
        addSubview(separatorView)
    }
    
    private func setupTextFieldViewConstraints() {
        textFiled.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        textFiled.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        textFiled.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separatorView.topAnchor.constraint(equalTo: textFiled.bottomAnchor, constant: 5).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
}
