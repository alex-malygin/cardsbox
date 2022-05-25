//
//  BaseButtonView.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/25/22.
//

import UIKit

final class BaseButtonView: ReusableView {
    fileprivate var button: UIButton!
    
    //MARK: - PROPERTIES FOR SETUP TEXT FIELD
    var title: String? {
        didSet { button.setTitle(title, for: .normal) }
    }

    var image: UIImage? {
        didSet { button.setImage(image, for: .normal) }
    }

    var color: UIColor = .mainSkyBlue {
        didSet { button.backgroundColor = color }
    }

    var action: VoidClosure?
    
    override func setupView() {
        setupButton()
        setupConstraints()
    }
}

//MARK: - SETUP ELEMENTS
extension BaseButtonView {
    private func setupButton() {
        button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.backgroundColor = color
        button.setTitle("Button", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        addSubview(button)
    }
    
    private func setupConstraints() {
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc private func buttonAction() {
        UIView.animate(withDuration: 0.1,
                       animations: {
            self.button.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.button.transform = CGAffineTransform.identity
            }
        })
        
        action?()
    }
}
