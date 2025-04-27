//
//  WelcomeViewController.swift
//  WelcomePresentation
//
//  Created by Iacob Zanoci on 27.04.2025.
//

import DesignSystem
import UIComponents
import UIKit

public final class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: WelcomeViewModelProtocol
    
    // MARK: - Views
    
    private lazy var welcomeView: UIView = {
        let view = WelcomeView(
            onCreateAccount: { [weak self] in
                self?.viewModel.onCreateAccount()
            },
            onLogIn: { [weak self] in
                self?.viewModel.onLogIn()
            }
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
    
    public init(viewModel: WelcomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.backgroundColor = .Piczy.background
        view.addSubview(welcomeView)
        
        let constraints = [
            welcomeView.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            welcomeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

private struct ViewModelFixture: WelcomeViewModelProtocol {
    func onCreateAccount() {}
    func onLogIn() {}
}

#Preview {
    WelcomeViewController(
        viewModel: ViewModelFixture()
    )
}
