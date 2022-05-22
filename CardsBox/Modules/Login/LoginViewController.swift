//
//  LoginViewController.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

private extension LoginViewController {
    private func calculateSize(with percent: Int) -> CGFloat {
        let screenSize = UIScreen.screenHeight
        return screenSize * CGFloat(percent) / 100
    }
}

class LoginViewController: BaseViewController<LoginViewModelType> {
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet private var accountLabel: UILabel!
    private var formBackgroundView: UIView!
    private var formLabel: UILabel!
    private var emailTextField: BaseTextFieldView!
    private var passwordTextField: BaseTextFieldView!
    
    private var backgroundCircle: UIView!
    private var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor(hexString: "#91EAE4").cgColor,
            UIColor.mainSkyBlue.cgColor,
            UIColor.sky.cgColor
        ]
        gradient.locations = [0, 0.50, 1]
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundCircle()
        setupFormView()
        
        setupBackgroundCircleConstraints()
        setupFormConstraints()
        
        setupUIElements()
        
        viewModel.input.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradient.frame = backgroundCircle.bounds
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
    }
}

//MARK: - SETUP BACKGROUD CIRCLE
private extension LoginViewController {
    private func setupBackgroundCircle() {
        backgroundCircle = UIView()
        backgroundCircle.translatesAutoresizingMaskIntoConstraints = false
        gradient.cornerRadius = UIScreen.screenWidth
        backgroundCircle.layer.addSublayer(gradient)
        view.addSubview(backgroundCircle)
    }
    
    private func setupFormView() {
        formBackgroundView = UIView()
        formBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        formBackgroundView.layer.cornerRadius = 25
        formBackgroundView.backgroundColor = .white
        formBackgroundView.layer.shadowColor = UIColor.black.cgColor
        formBackgroundView.layer.shadowOffset = CGSize(width: 3, height: 3)
        formBackgroundView.layer.shadowOpacity = 0.3
        formBackgroundView.layer.shadowRadius = 4.0
        view.addSubview(formBackgroundView)
        
        formLabel = UILabel()
        formLabel.translatesAutoresizingMaskIntoConstraints = false
        formLabel.text = Strings.loginTitle
        formLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        formLabel.textAlignment = .center
        formBackgroundView.addSubview(formLabel)
        
        emailTextField = BaseTextFieldView()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        formBackgroundView.addSubview(emailTextField)
        
        passwordTextField = BaseTextFieldView()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        formBackgroundView.addSubview(passwordTextField)
    }
    
    private func setupBackgroundCircleConstraints() {
        backgroundCircle.widthAnchor.constraint(equalToConstant: UIScreen.screenWidth * 2).isActive = true
        backgroundCircle.heightAnchor.constraint(equalToConstant: UIScreen.screenWidth * 2).isActive = true
        backgroundCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -UIScreen.screenWidth).isActive = true
    }
    
    private func setupFormConstraints() {
        formBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: calculateSize(with: 30)).isActive = true
        formBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        formBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        formBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        formBackgroundView.bottomAnchor.constraint(lessThanOrEqualTo: accountLabel.topAnchor, constant: 15).isActive = true
        
        formLabel.topAnchor.constraint(equalTo: formBackgroundView.topAnchor, constant: 15).isActive = true
        formLabel.leadingAnchor.constraint(equalTo: formBackgroundView.leadingAnchor, constant: 15).isActive = true
        formLabel.trailingAnchor.constraint(equalTo: formBackgroundView.trailingAnchor, constant: -15).isActive = true
        
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.topAnchor.constraint(equalTo: formLabel.bottomAnchor, constant: 15).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: formBackgroundView.leadingAnchor, constant: 15).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: formBackgroundView.trailingAnchor, constant: -15).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -15).isActive = true
        
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: formBackgroundView.leadingAnchor, constant: 15).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: formBackgroundView.trailingAnchor, constant: -15).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: formBackgroundView.bottomAnchor, constant: -15).isActive = true
    }
}

//MARK: - SETUP UI ELEMENTS
private extension LoginViewController {
    private func setupUIElements() {
        //Account label
        accountLabel.text = Strings.loginSubtitle
        accountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        //Register button
        registerButton.setTitle(Strings.registrationButton, for: .normal)
        let gradient = getGradientLayer(bounds: registerButton.bounds, colors: [UIColor(hexString: "#f12711").cgColor,
                                                                                UIColor(hexString: "#f5af19").cgColor])
        registerButton.setTitleColor(gradientColor(bounds: registerButton.bounds, gradientLayer: gradient), for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
}
