//
//  WelcomeView.swift
//  WelcomePresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import DesignSystem
import UIComponents
import UIKit

final class WelcomeView: UIView {
    // MARK: - Types
    
    private enum Constants {
        static let buttonHeight = 48.0
        static let backgroundOffset = -200.0
        static let animationDelayInSeconds = 2.0
        static let animationDurationInSeconds = 0.2
    }
    
    // MARK: - Properties
    
    private let onCreateAccountAction: () -> Void
    private let onLogInAction: () -> Void
    
    // MARK: - Constraints
    
    private var backgroundTopConstraint: NSLayoutConstraint?
    private var backgroundBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Views
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "LaunchScreen", in: .module, with: .none)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var createAccountButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Create Account", for: .normal)
        button.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var logInButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var disclaimerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Piczy.secondaryText
        label.font = .Piczy.caption
        label.text = "By proceeding you agree to some random terms of service and privacy policy."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .Piczy.background
        stackView.axis = .vertical
        stackView.spacing = .medium
        return stackView
    }()
    
    // MARK: - Actions
    
    @objc private func createAccountAction() {
        onCreateAccountAction()
    }
    
    @objc private func logInAction() {
        onLogInAction()
    }
    
    // MARK: - Initializers
    
    init(
        onCreateAccount: @escaping () -> Void,
        onLogIn: @escaping () -> Void
    ) {
        onCreateAccountAction = onCreateAccount
        onLogInAction = onLogIn
        
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented.")
    }
}

// MARK: - Layout Setup

extension WelcomeView {
    
    private func setupLayout() {
        backgroundColor = .Piczy.background
        setupBackgroundImageView()
        setupButtonStackView()
        animateButtonStackReveal(after: Constants.animationDelayInSeconds)
    }
    
    private func setupBackgroundImageView() {
        addSubview(backgroundImageView)
        
        backgroundTopConstraint = backgroundImageView.topAnchor.constraint(
            equalTo: topAnchor)
        
        backgroundBottomConstraint = backgroundImageView.bottomAnchor.constraint(
            equalTo: bottomAnchor
        )
        
        let constraints = [
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundTopConstraint!,
            backgroundBottomConstraint!
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupButtonStackView() {
        buttonStackView.addArrangedSubview(createAccountButton)
        buttonStackView.addArrangedSubview(logInButton)
        buttonStackView.addArrangedSubview(disclaimerLabel)
        
        addSubview(buttonStackView)
        
        let constraints = [
            createAccountButton.heightAnchor.constraint(
                equalToConstant: Constants.buttonHeight
            ),
            logInButton.heightAnchor.constraint(
                equalToConstant: Constants.buttonHeight
            ),
            buttonStackView.topAnchor.constraint(
                equalTo: backgroundImageView.bottomAnchor,
                constant: .medium
            ),
            buttonStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: .medium
            ),
            buttonStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -.medium
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func animateButtonStackReveal(after duration: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.backgroundTopConstraint?.constant = Constants.backgroundOffset
            self?.backgroundBottomConstraint?.constant = Constants.backgroundOffset
            UIView.animate(withDuration: Constants.animationDurationInSeconds) {
                self?.layoutIfNeeded()
            }
        }
    }
}

#Preview {
    WelcomeView(
        onCreateAccount: {},
        onLogIn: {}
    )
}
