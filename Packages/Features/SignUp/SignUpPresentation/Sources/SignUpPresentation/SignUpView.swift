//
//  SignUpView.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import UIKit
import DesignSystem
import UIComponents

final class SignUpView: UIView {
    
    // MARK:  - Types
    
    private enum Constants {
        static let buttonHeight = 48.0
        static let padding: CGFloat = 50.0
    }
    
    // MARK: - Properties
    
    private var viewModel: SignUpViewModelProtocol
    
    // MARK: - Constraints
    
    public var centerYConstraint: NSLayoutConstraint?
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = .Piczy.titleBold
        label.textColor = .Piczy.primaryText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var emailTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "Enter your email"
        textField.error = nil
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "Enter your password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var confirmPasswordTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "Confirm your password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var createAccountButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Create Account", for: .normal)
        button.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .Piczy.background
        stackView.axis = .vertical
        stackView.spacing = .extraLarge
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Actions
    
    /// Handles changes in text fields to validate form input.
    @objc private func textFieldDidChange() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
        
        createAccountButton.isEnabled = viewModel.validateCredentials()
    }
    
    @objc private func createAccountAction() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
        
        // Email Validation
        if !viewModel.isValidEmail(viewModel.email) {
            emailTextField.error = "Invalid email"
            return
        } else {
            emailTextField.error = nil
        }
        
        // Password Validation
        if !viewModel.isValidPassword(viewModel.password) {
            passwordTextField.error = "Invalid password"
            return
        } else {
            passwordTextField.error = nil
        }
        
        // Confirm Password Validation
        if viewModel.password != viewModel.confirmPassword {
            confirmPasswordTextField.error = "Passwords do not match"
            return
        } else {
            confirmPasswordTextField.error = nil
        }
        
        // Further logic for the user signUp
        print("Success")
        viewModel.onSignUpSuccess?()
    }
    
    // MARK: - Initializers
    
    init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Setup

extension SignUpView {
    
    private func setupLayout() {
        backgroundColor = .Piczy.background
        setupButtonStackView()
    }
    
    private func setupButtonStackView() {
        buttonStackView.addArrangedSubview(titleLabel)
        buttonStackView.addArrangedSubview(emailTextField)
        buttonStackView.addArrangedSubview(passwordTextField)
        buttonStackView.addArrangedSubview(confirmPasswordTextField)
        buttonStackView.addArrangedSubview(createAccountButton)
        
        // Add stack view to the main view
        addSubview(buttonStackView)
        
        buttonStackView.setContentHuggingPriority(.required, for: .vertical)
        buttonStackView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        emailTextField.heightAnchor.constraint(equalToConstant: .extraLarge).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: .extraLarge).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: .extraLarge).isActive = true
        
        NSLayoutConstraint.activate([
            createAccountButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding)
        ])
        
        centerYConstraint = buttonStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint?.isActive = true
    }
}
