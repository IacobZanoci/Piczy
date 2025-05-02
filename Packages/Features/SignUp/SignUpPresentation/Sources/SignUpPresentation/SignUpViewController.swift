//
//  SignUpViewController.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import UIKit
import DesignSystem
import UIComponents

public final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: SignUpViewModelProtocol
    
    // MARK: - Views
    
    private lazy var signUpView: SignUpView = {
        let view = SignUpView(
            onEmailTextChanged: { [weak self] email in
                self?.viewModel.onEmailChanged(to: email)
            },
            onPasswordTextChange: { [weak self] password in
                self?.viewModel.onPasswordChanged(to: password)
            },
            onConfirmPasswordTextChange: { [weak self] confirmPassword in
                self?.viewModel.onConfirmPasswordChanged(to: confirmPassword)
            },
            onSignUpButtonTapped: { [weak self] in
                self?.viewModel.onSignUp()
            }
        )
        return view
    }()
    
    // MARK: - Initializers
    
    public init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.backgroundColor = .Piczy.background
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpView)
        
        let constraints = [
            signUpView.topAnchor.constraint(equalTo: view.topAnchor),
            signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        setupKeyboardNotifications()
    }
    
    // MARK: - Keyboard Handling
    
    /// Observers keyboard appearance. Adjust the layout dynamically.
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    /// Animates layout changes when the keyboard appears or disappears.
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        let animationCurve = UIView.AnimationOptions(rawValue: curveValue << 16)
        
        // Keyboard visibility handling
        if endFrame.origin.y >= UIScreen.main.bounds.height {
            // Keyboard is hidden — reset position
            signUpView.centerYConstraint?.constant = 0
        } else {
            // Keyboard is visible — move view slightly up (44pt)
            signUpView.centerYConstraint?.constant = -44
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: animationCurve,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    /// Conects ViewModel outputs to View's display logic.
    private func bindViewModel() {
        viewModel.onEmailErrorChanged = { [weak self] errorMessage in
            self?.signUpView.showEmailError(errorMessage)
        }
        
        viewModel.onPasswordErrorChanged = { [weak self] errorMessage in
            self?.signUpView.showPasswordError(errorMessage)
        }
        
        viewModel.onConfirmPasswordErrorChanged = { [weak self] errorMessage in
            self?.signUpView.showConfirmPasswordError(errorMessage)
        }
        
        viewModel.onSignUpButtonEnabled = { [weak self] isEnable in
            self?.signUpView.enableSignUpButton(isEnable: isEnable)
        }
    }
}

// MARK: - Preview

private final class ViewModelFixture: SignUpViewModelProtocol {
    var onEmailErrorChanged: ((String?) -> Void)?
    
    var onPasswordErrorChanged: ((String?) -> Void)?
    
    var onConfirmPasswordErrorChanged: ((String?) -> Void)?
    
    var onSignUpButtonEnabled: ((Bool) -> Void)?
    
    func onEmailChanged(to email: String) {
        onEmailErrorChanged?(email.contains("@") ? nil : "Invalid email")
    }
    
    func onPasswordChanged(to password: String) {
        onPasswordErrorChanged?(password.count >= 6 ? nil : "Password too short")
    }
    
    func onConfirmPasswordChanged(to confirmPassword: String) {
        onConfirmPasswordErrorChanged?(confirmPassword == "password" ? nil : "Passwords do not match")
    }
    
    func onSignUp() {
        print("Success")
    }
}

#Preview {
    SignUpViewController(
        viewModel: ViewModelFixture()
    )
}
