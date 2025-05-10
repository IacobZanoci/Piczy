import XCTest
@testable import LoginPresentation
@testable import LoginDomain
@testable import CredentialsValidator
@testable import NetworkClient

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    func test_givenValidCredentials_whenLoginSucceeds_thenTriggersLoginAction() async {
        let expectation = XCTestExpectation()
        var didCallOnLogin = false
        
        let viewModel = LoginViewModel(
            onLogin: {
                didCallOnLogin = true
                expectation.fulfill()
            },
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(shouldEmailBeValid: true, shouldPasswordBeValid: true),
            loginService: MockLoginServiceForTests(expectedSignInResponse: .success(LoginResponse(token: "piczyToken")))
        )
        
        viewModel.onEmailChanged(to: "piczy@gmail.com")
        viewModel.onPasswordChanged(to: "123456")
        viewModel.onLogin()
        
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(didCallOnLogin)
    }
    
    func test_givenInvalidCredentials_whenLoginFails_thenSetsErrorMessage() async {
        let expectation = XCTestExpectation()
        var capturedError: String?
        
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(shouldEmailBeValid: true, shouldPasswordBeValid: true),
            loginService: MockLoginServiceForTests(expectedSignInResponse: .failure(.invalidCredentials))
        )
        
        viewModel.onErrorCredentials = { error in
            capturedError = error
            expectation.fulfill()
        }
        
        viewModel.onEmailChanged(to: "yzcip@gmail.com")
        viewModel.onPasswordChanged(to: "654321")
        viewModel.onLogin()
        
        await fulfillment(of: [expectation], timeout: 0.1)
        
        XCTAssertEqual(capturedError, "Wrong email address or password")
    }
}
