//
//  SignUpViewController.swift
//  SignUpPresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import UIKit
import DesignSystem

public final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: SignUpViewModelProtocol
    
    // MARK: - Views
    
    private lazy var signUpView: SignUpView = {
        let view = SignUpView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    public init(viewModel: SignUpViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupLayout() {
        view.backgroundColor = .Piczy.background
        view.addSubview(signUpView)
        
        NSLayoutConstraint.activate([
            signUpView.topAnchor.constraint(equalTo: view.topAnchor),
            signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
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
}

private struct ViewModelFixture: SignUpViewModelProtocol {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var onSignUpSuccess: (() -> Void)?
    
    func validateCredentials() -> Bool { true }
    func isValidEmail(_ email: String) -> Bool { true }
    func isValidPassword(_ password: String) -> Bool { true }
}

#Preview {
    SignUpViewController(
        viewModel: ViewModelFixture()
    )
}
