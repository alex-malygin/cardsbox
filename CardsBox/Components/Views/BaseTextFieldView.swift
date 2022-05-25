//
//  BaseTextFieldView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/22/22.
//

import UIKit

final class BaseTextFieldView: ReusableView {
    fileprivate var textField: UITextField!
    fileprivate var separatorView: UIView!
    fileprivate let trailingButton = UIButton()
    fileprivate var textFieldTrailingConstrint: NSLayoutConstraint?
    
    var handleText: Observer<String?> = .init(nil)
    var trailingElementAction: VoidClosure?
    
    //MARK: - PROPERTIES FOR SETUP TEXT FIELD
    var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var textContentType: UITextContentType? {
        get { textField.textContentType }
        set { textField.textContentType = newValue }
    }

    var correction: Bool {
        get { textField.autocorrectionType == .yes }
        set { textField.autocorrectionType = newValue ? .yes : .no }
    }

    var capitalization: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    var isSecurity: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    override func setupView() {
        setupTextFieldView()
        setupTextFieldViewConstraints()
    }
}

//MARK: - SETUP ELEMENTS
extension BaseTextFieldView {
    private func setupTextFieldView() {
        backgroundColor = .clear
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.returnKeyType = .default
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "placeholder"
        textField.addDoneButtonOnKeyboard()
        textField.addTarget(self, action: #selector(handleTextAction), for: .editingChanged)
        
        addSubview(textField)
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .gray.withAlphaComponent(0.2)
        addSubview(separatorView)
    }
    
    private func setupTextFieldViewConstraints() {
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        textFieldTrailingConstrint = textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2)
        textFieldTrailingConstrint?.isActive = true
        
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separatorView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    @objc private func handleTextAction(_ sender: UITextField) {
        handleText.value = sender.text
    }
}

//MARK: - RIGHT ELEMENT SETUP
extension BaseTextFieldView {
    func setTrailingElement(image: UIImage?) {
        trailingButton.translatesAutoresizingMaskIntoConstraints = false
        trailingButton.setImage(image, for: .normal)
        trailingButton.tintColor = .label
        trailingButton.addTarget(self, action: #selector(trailingAction), for: .touchUpInside)
        addSubview(trailingButton)
        
        textFieldTrailingConstrint?.isActive = false
        trailingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        trailingButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        trailingButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 2).isActive = true
        trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
    }
    
    func setTrailingElementImage(_ image: UIImage?) {
        trailingButton.setImage(image, for: .normal)
    }
    
    @objc fileprivate func trailingAction() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        trailingElementAction?()
    }
}
