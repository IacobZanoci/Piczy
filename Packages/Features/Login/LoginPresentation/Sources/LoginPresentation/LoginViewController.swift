//
//  LoginViewController.swift
//  LoginPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import UIKit

public class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: LoginViewModelProtocol
    
    // MARK: - Views
    
    private lazy var loginFormView: LoginView = {
        let view = LoginView(
            onEmailTextChanged: { [weak self] email in
                self?.viewModel.onEmailChanged(to: email)
            },
            onPasswordTextChanged: { [weak self] password in
                self?.viewModel.onPasswordChanged(to: password)
            },
            onLoginButtonTapped: { [weak self] in
                self?.viewModel.onLogin()
            },
            onForgotPasswordButtonTapped: { [weak self] in
                self?.viewModel.onForgotPassword()
            },
            onCreateAccountButtonTapped: { [weak self] in
                self?.viewModel.onCreateAccount()
            }
        )
        return view
    }()
    
    // MARK: - Initializers
    
    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    // MARK: - Layout Setup
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Piczy.primaryButton
        setupLayout()
        setupKeyboardObservers()
        bindViewModel()
    }
    
    private func setupLayout() {
        view.addSubview(loginFormView)
        loginFormView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginFormView.topAnchor.constraint(equalTo: view.topAnchor),
            loginFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
        loginFormView.updateStackViewPosition(for: height)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        loginFormView.updateStackViewPosition(for: 0)
    }
    
    // MARK: - Events
    
    private func bindViewModel() {
        viewModel.onEmailErrorChanged = { [weak self] errorMessage in
            self?.loginFormView.showEmailError(errorMessage)
        }
        
        viewModel.onPasswordErrorChanged = { [weak self] errorMessage in
            self?.loginFormView.showPasswordError(errorMessage)
        }
        
        viewModel.onLoginButtonEnabled = { [weak self] isEnable in
            self?.loginFormView.enableLoginButton(isEnable: isEnable)
        }
    }
}
