//
//  LoginView.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import DesignSystem
import UIComponents
import UIKit

public class LoginView: UIView {
    
    // MARK: - Types
    
    private enum Constants {
        static let loginButtonHeight: CGFloat = 48
        static let whiteAlpha: CGFloat = 0.7
        static let startColorAlpha: CGFloat = 0.3
        static let distanceFromBottom: CGFloat = -200
        static let keyboardDivisionFactor: CGFloat = 4
        static let stackViewMovementAnimationDuration: TimeInterval = 0.3
    }
    
    // MARK: - Constraints
    
    private var centerYConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private var onEmailTextChanged: ((String) -> Void)?
    private let onPasswordTextChanged: ((String) -> Void)?
    private let onLoginButtonTapped: () -> Void
    private let onForgotPasswordButtonTapped: () -> Void
    private let onCreateAccountButtonTapped: () -> Void
    
    // MARK: - Views
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "Login", in: .module, with: .none)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Log In", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot your password?", for: .normal)
        button.titleLabel?.font = .Piczy.caption
        button.setTitleColor(.Piczy.primaryText, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let firstPart = "Don't have an account? "
        let secondPart = "Join"
        let attributedTitle = NSMutableAttributedString(string: firstPart)
        let secondPartAttributed = NSAttributedString(string: secondPart, attributes: [.font: UIFont.Piczy.bodyBold ])
        attributedTitle.append(secondPartAttributed)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.font = .Piczy.body
        button.setTitleColor(.Piczy.primaryText, for: .normal)
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var whiteGradientFadeView: UIView = {
        let view = UIView()
        var frame = UIScreen.main.bounds
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(Constants.whiteAlpha).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: Constants.startColorAlpha)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    public lazy var emailTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "Email"
        textField.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    public lazy var passwordTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = .Piczy.titleBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var spacerView: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .large
        return stack
    }()
    
    // MARK: - Actions
    
    @objc private func emailTextChanged(_ sender: UITextField) {
        onEmailTextChanged?(sender.text ?? "")
    }
    
    @objc private func passwordTextChanged(_ sender: UITextField) {
        onPasswordTextChanged?(sender.text ?? "")
    }
    
    @objc private func loginButtonTapped() {
        onLoginButtonTapped()
    }
    
    @objc private func forgotPasswordButtonTapped() {
        onForgotPasswordButtonTapped()
    }
    
    @objc private func createAccountButtonTapped() {
        onCreateAccountButtonTapped()
    }
    
    // MARK: - Events
    
    func showEmailError(_ message: String?) {
        emailTextField.error = message
    }
    
    func showPasswordError(_ message: String?) {
        passwordTextField.error = message
    }
    
    func enableLoginButton(isEnable: Bool) {
        loginButton.isEnabled = isEnable
    }
    
    func updateStackViewPosition(for keyboardHeight: CGFloat) {
        guard keyboardHeight >= 0 else { return }
        centerYConstraint.constant = -(keyboardHeight / Constants.keyboardDivisionFactor)
        
        UIView.animate(withDuration: Constants.stackViewMovementAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Initializers
    
    init(
        onEmailTextChanged: ((String) -> Void)?,
        onPasswordTextChanged: ((String) -> Void)?,
        onLoginButtonTapped: @escaping () -> Void,
        onForgotPasswordButtonTapped: @escaping () -> Void,
        onCreateAccountButtonTapped: @escaping () -> Void
    ) {
        self.onEmailTextChanged = onEmailTextChanged
        self.onPasswordTextChanged = onPasswordTextChanged
        self.onLoginButtonTapped = onLoginButtonTapped
        self.onForgotPasswordButtonTapped = onForgotPasswordButtonTapped
        self.onCreateAccountButtonTapped = onCreateAccountButtonTapped
        
        super.init(frame: .zero)
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented.")
    }
}

// MARK: - Layout Setup

extension LoginView {
    
    private func setupViewLayout() {
        setupBackgroundView()
        setupStackView()
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundImageView)
        addSubview(whiteGradientFadeView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            whiteGradientFadeView.topAnchor.constraint(equalTo: topAnchor),
            whiteGradientFadeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteGradientFadeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            whiteGradientFadeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.distanceFromBottom)
        ])
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(loginTitleLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(forgotPasswordButton)
        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(createAccountButton)
        addSubview(stackView)
        centerYConstraint = stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        centerYConstraint?.isActive = true
        
        let stackViewConstraints = [
            loginButton.heightAnchor.constraint(equalToConstant: Constants.loginButtonHeight),
            emailTextField.heightAnchor.constraint(equalToConstant: .extraLarge),
            passwordTextField.heightAnchor.constraint(equalToConstant: .extraLarge),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: .small),
            createAccountButton.heightAnchor.constraint(equalToConstant: .medium),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .extraLarge),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.extraLarge)
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
    }
}
