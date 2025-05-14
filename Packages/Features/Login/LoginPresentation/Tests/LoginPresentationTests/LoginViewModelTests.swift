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
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: true,
                shouldPasswordBeValid: true
            ),
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
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: true,
                shouldPasswordBeValid: true
            ),
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
    
    func test_givenEmptyEmail_whenValidateEmail_thenShouldNotDisplayErrorMessage() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: true,
                shouldPasswordBeValid: true
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var receivedEmailError: String?
        viewModel.onEmailErrorChanged = { error in
            receivedEmailError = error
        }
        
        viewModel.onEmailChanged(to: "")
        viewModel.onLogin()
        
        XCTAssertNil(receivedEmailError, "Expected no error message when email is empty")
    }
    
    func test_givenValidEmail_whenValidateEmail_thenShouldNotDisplayErrorMessage() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: true,
                shouldPasswordBeValid: true
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var receivedEmailError: String?
        viewModel.onEmailErrorChanged = { error in
            receivedEmailError = error
        }
        
        viewModel.onEmailChanged(to: "piczy@gmail.com")
        viewModel.onLogin()
        
        XCTAssertNil(receivedEmailError, "Expected no error message when email is valid")
    }
    
    func test_givenInvalidEmail_whenValidateEmail_thenShouldDisplayErrorMessage() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: false,
                shouldPasswordBeValid: true
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var receivedEmailError: String?
        viewModel.onEmailErrorChanged = { error in
            receivedEmailError = error
        }
        
        viewModel.onEmailChanged(to: "piczy@invalidUser")
        viewModel.onLogin()
        
        XCTAssertEqual(receivedEmailError, "The email entered isn't valid.", "Expected specific error message for invalid email.")
    }
    
    func test_givenValidPassword_whenValidatePassword_thenShouldNotDisplayErrorMessage() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: true,
                shouldPasswordBeValid: true
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var receivedPasswordError: String?
        viewModel.onPasswordErrorChanged = { error in
            receivedPasswordError = error
        }
        
        viewModel.onPasswordChanged(to: "123456")
        viewModel.onLogin()
        
        XCTAssertNil(receivedPasswordError, "Expected no error message when password is valid.")
    }
    
    func test_givenInvalidPassword_whenValidatePassword_thenShouldDisplayErrorMessage() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: false,
                shouldPasswordBeValid: false
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var receivedPasswordError: String?
        viewModel.onPasswordErrorChanged = { error in
            receivedPasswordError = error
        }
        
        viewModel.onPasswordChanged(to: "123")
        viewModel.onLogin()
        
        XCTAssertEqual(receivedPasswordError, "Password is too short.", "Expected specific error message for invalid password.")
    }
    
    func test_givenValidEmailAndValidPassword_whenUpdateLoginButtonState_thenShouldEnableLoginButton() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: true,
                shouldPasswordBeValid: true
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var isLoginButtonEnabled: Bool?
        viewModel.onLoginButtonEnabled = { isEnabled in
            isLoginButtonEnabled = isEnabled
        }
        
        viewModel.onEmailChanged(to: "piczy@gmail.com")
        viewModel.onPasswordChanged(to: "123456")
        viewModel.onLogin()
        
        XCTAssertTrue(isLoginButtonEnabled ?? false, "Expected login button to be enabled when both email and password are valid.")
    }
    
    func test_givenInvalidEmailAndValidPassword_whenUpdateLoginButtonState_thenShouldDisableLoginButton() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: false,
                shouldPasswordBeValid: true
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var isLoginButtonEnabled: Bool?
        viewModel.onLoginButtonEnabled = { isEnabled in
            isLoginButtonEnabled = isEnabled
        }
        
        viewModel.onEmailChanged(to: "piczy@invalidUser")
        viewModel.onPasswordChanged(to: "123456")
        viewModel.onLogin()
        
        XCTAssertFalse(isLoginButtonEnabled ?? true, "Expected login button to be disabled when email is invalid and password is valid.")
    }
    
    func test_givenValidEmailAndInvalidPassword_whenUpdateLoginButtonState_thenShouldDisableLoginButton() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: true,
                shouldPasswordBeValid: false
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var isLoginButtonEnabled: Bool?
        viewModel.onLoginButtonEnabled = { isEnabled in
            isLoginButtonEnabled = isEnabled
        }
        
        viewModel.onEmailChanged(to: "piczy@gmail.com")
        viewModel.onPasswordChanged(to: "123")
        viewModel.onLogin()
        
        XCTAssertFalse(isLoginButtonEnabled ?? true, "Expected login button to be disabled when email is valid and password is invalid.")
    }
    
    func test_givenInvalidEmailAndInvalidPassword_whenUpdateLoginButtonState_thenShouldDisableLoginButton() {
        let viewModel = LoginViewModel(
            onLogin: {},
            onForgotPassword: {},
            onCreateAccount: {},
            credentialsValidator: MockCredentialsValidator(
                shouldEmailBeValid: false,
                shouldPasswordBeValid: false
            ),
            loginService: MockLoginServiceForTests(
                expectedSignInResponse: .failure(.invalidCredentials)
            )
        )
        
        var isLoginButtonEnabled: Bool?
        viewModel.onLoginButtonEnabled = { isEnabled in
            isLoginButtonEnabled = isEnabled
        }
        
        viewModel.onEmailChanged(to: "piczy@invalidUser")
        viewModel.onPasswordChanged(to: "123")
        viewModel.onLogin()
        
        XCTAssertFalse(isLoginButtonEnabled ?? true, "Expected login button to be disabled when email is invalid and password is invalid.")
    }
    
    
}
