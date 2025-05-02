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
    
    // MARK: - Types
    
    private enum Constants {
        static let buttonHeight: CGFloat = 48.0
        static let padding: CGFloat = 50.0
    }
    
    // MARK: - Properties
    
    private var onEmailTextChanged: ((String) -> Void)?
    private var onPasswordTextChange: ((String) -> Void)?
    private var onConfirmPasswordTextChange: ((String) -> Void)?
    private var onSignUpButtonTapped: () -> Void
    
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
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "Enter your password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var confirmPasswordTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "Confirm your password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(confirmPasswordTextChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var signUpButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Create account", for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .extraLarge
        stack.alignment = .fill
        return stack
    }()
    
    // MARK: - Actions
    
    @objc private func emailTextChanged(sender: UITextField) {
        onEmailTextChanged?(sender.text ?? "")
    }
    
    @objc private func passwordTextChanged(sender: UITextField) {
        onPasswordTextChange?(sender.text ?? "")
    }
    
    @objc private func confirmPasswordTextChanged(sender: UITextField) {
        onConfirmPasswordTextChange?(sender.text ?? "")
    }
    
    @objc private func signUpButtonTapped() {
        onSignUpButtonTapped()
    }
    
    // MARK: - Events
    
    func showEmailError(_ message: String?) {
        emailTextField.error = message
    }
    
    func showPasswordError(_ message: String?) {
        passwordTextField.error = message
    }
    
    func showConfirmPasswordError(_ message: String?) {
        confirmPasswordTextField.error = message
    }
    
    func enableSignUpButton(isEnable: Bool) {
        signUpButton.isEnabled = isEnable
    }
    
    // MARK: - Initializers
    
    init(
        onEmailTextChanged: ((String) -> Void)?,
        onPasswordTextChange: ((String) -> Void)?,
        onConfirmPasswordTextChange: ((String) -> Void)?,
        onSignUpButtonTapped: @escaping () -> Void
    ) {
        self.onEmailTextChanged = onEmailTextChanged
        self.onPasswordTextChange = onPasswordTextChange
        self.onConfirmPasswordTextChange = onConfirmPasswordTextChange
        self.onSignUpButtonTapped = onSignUpButtonTapped
        super.init(frame: .zero)
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Setup

extension SignUpView {
    
    private func setupViewLayout() {
        backgroundColor = .Piczy.background
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(signUpButton)
        addSubview(stackView)
        
        emailTextField.heightAnchor.constraint(equalToConstant: .extraLarge).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: .extraLarge).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: .extraLarge).isActive = true
        
        let constraints = [
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding)
        ]
        NSLayoutConstraint.activate(constraints)
        
        centerYConstraint = stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerYConstraint?.isActive = true
    }
}
