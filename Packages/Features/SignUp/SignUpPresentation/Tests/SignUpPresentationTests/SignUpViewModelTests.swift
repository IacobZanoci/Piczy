import XCTest
@testable import SignUpPresentation
@testable import SignUpDomain
@testable import NetworkClient
@testable import CredentialsValidator

final class SignUpViewModelTests: XCTestCase {
    
    @MainActor
    func test_givenValidCredentials_whenSignUp_thenTriggersSignUpAction() async {
        
        let expectation = XCTestExpectation()
        var didCallOnSignUp = false
        
        let sut = SignUpViewModel(
            onSignUp: {
                didCallOnSignUp = true
                expectation.fulfill()
            },
            credentialsValidator: MockCredentialsValidator(shouldEmailBeValid: true,
                                                           shouldPasswordBeValid: true,
                                                           shouldConfirmPasswordBeValid: true),
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        sut.onEmailChanged(to: "newPiczy@gmail.com")
        sut.onPasswordChanged(to: "123456")
        sut.onConfirmPasswordChanged(to: "123456")
        
        sut.onSignUp()
        
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(didCallOnSignUp)
    }
    
    @MainActor
    func test_givenDuplicateEmail_whenSignUp_thenSetsEmailError() async {
        
        let expectation = XCTestExpectation()
        var capturedError: String?
        
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: MockCredentialsValidator(),
            signUpService: MockSignUpServiceForTest(result: .failure(.emailAlreadyExists))
        )
        
        sut.onEmailErrorChanged = { error in
            capturedError = error
            expectation.fulfill()
        }
        
        sut.onEmailChanged(to: "piczy@gmail.com")
        sut.onPasswordChanged(to: "123456")
        sut.onConfirmPasswordChanged(to: "123456")
        
        sut.onSignUp()
        
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(capturedError, "Email already in use")
    }
    
    @MainActor
    func test_givenUnknownError_whenSignUp_thenSetsEmailError() async {
        
        let expectation = XCTestExpectation()
        var capturedError: String?
        
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: MockCredentialsValidator(),
            signUpService: MockSignUpServiceForTest(result: .failure(.unknown))
        )
        
        sut.onEmailErrorChanged = { error in
            capturedError = error
            expectation.fulfill()
        }
        
        sut.onEmailChanged(to: "newPiczy@gmail.com")
        sut.onPasswordChanged(to: "123456")
        sut.onConfirmPasswordChanged(to: "123456")
        
        sut.onSignUp()
        
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(capturedError, "Unknown error")
    }
    
    @MainActor
    func test_givenInvalidEmail_whenEmailTextFieldChanged_thenSetsEmailErrorLabelMessage() {
        
        let validator = MockCredentialsValidator(shouldEmailBeValid: false)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var capturedEmailError: String?
        
        sut.onEmailErrorChanged = { error in
            capturedEmailError = error
        }
        
        sut.onEmailChanged(to: "piczy@gmail")
        
        XCTAssertEqual(capturedEmailError, "Email is not valid")
    }
    
    @MainActor
    func test_givenValidEmail_whenEmailTextFieldChanged_thenSetsEmailErrorLabelToNil() {
        
        let validator = MockCredentialsValidator(shouldEmailBeValid: true)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var capturedEmailError: String?
        
        sut.onEmailErrorChanged = { error in
            capturedEmailError = error
        }
        
        sut.onEmailChanged(to: "piczy@gmail.com")
        
        XCTAssertNil(capturedEmailError)
    }
    
    @MainActor
    func test_givenInvalidPassword_whenPasswordTextFieldChanged_thenSetsPasswordErrorLabelMessage() {
        
        let validator = MockCredentialsValidator(shouldPasswordBeValid: false)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var capturedPasswordError: String?
        
        sut.onPasswordErrorChanged = { error in
            capturedPasswordError = error
        }
        
        sut.onPasswordChanged(to: "1")
        
        XCTAssertEqual(capturedPasswordError, "Password is not valid")
    }
    
    @MainActor
    func test_givenValidPassword_whenPasswordTextFieldChanged_thenSetsPasswordErrorLabelToNil() {
        
        let validator = MockCredentialsValidator(shouldPasswordBeValid: true)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var capturedPasswordError: String?
        
        sut.onPasswordErrorChanged = { error in
            capturedPasswordError = error
        }
        
        sut.onPasswordChanged(to: "123456")
        
        XCTAssertNil(capturedPasswordError)
    }
    
    @MainActor
    func test_givenInvalidConfirmPass_whenConfirmPasswordTextFieldChanged_thenSetsConfirmPasswordErrorLabelMessage() {
        
        let validator = MockCredentialsValidator(shouldConfirmPasswordBeValid: false)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var capturedConfirmPasswordError: String?
        
        sut.onConfirmPasswordErrorChanged = { error in
            capturedConfirmPasswordError = error
        }
        
        sut.onConfirmPasswordChanged(to: "123455")
        
        XCTAssertEqual(capturedConfirmPasswordError, "Passwords do not match")
    }
    
    @MainActor
    func test_givenValidConfirmPassword_whenConfirmPasswordTextFieldChanged_thenSetsConfirmPasswordErrorLabelToNil() {
        
        let validator = MockCredentialsValidator(shouldConfirmPasswordBeValid: true)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var capturedConfirmPasswordError: String?
        
        sut.onConfirmPasswordErrorChanged = { error in
            capturedConfirmPasswordError = error
        }
        
        sut.onConfirmPasswordChanged(to: "123456")
        
        XCTAssertNil(capturedConfirmPasswordError)
    }
    
    @MainActor
    func test_givenAllTextFieldsValid_whenTextFieldsChanged_thenEnablesSignUpButton() {
        
        let validator = MockCredentialsValidator(shouldEmailBeValid: true,
                                                 shouldPasswordBeValid: true,
                                                 shouldConfirmPasswordBeValid: true)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var isButtonEnabled: Bool?
        
        sut.onSignUpButtonEnabled = { isEnabled in
            isButtonEnabled = isEnabled
        }
        
        sut.onEmailChanged(to: "piczy@gmail.com")
        sut.onPasswordChanged(to: "123456")
        sut.onConfirmPasswordChanged(to: "123456")
        
        XCTAssertEqual(isButtonEnabled, true)
    }
    
    @MainActor
    func test_givenInvalidEmailTextField_whenTextFieldsChanged_thenKeepSignUpButtonDisabled() {
        
        let validator = MockCredentialsValidator(shouldEmailBeValid: false,
                                                 shouldPasswordBeValid: true,
                                                 shouldConfirmPasswordBeValid: true)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var isButtonEnabled: Bool?
        
        sut.onSignUpButtonEnabled = { isEnabled in
            isButtonEnabled = isEnabled
        }
        
        sut.onEmailChanged(to: "piczy@gmail.com")
        sut.onPasswordChanged(to: "123456")
        sut.onConfirmPasswordChanged(to: "123456")
        
        XCTAssertEqual(isButtonEnabled, false)
    }
    
    @MainActor
    func test_givenMatchingPasswords_whenTextFieldsChange_thenConfirmPasswordIsNilAndButtonIsEnabled() {
        
        let validator = MockCredentialsValidator(shouldEmailBeValid: true,
                                                 shouldPasswordBeValid: true,
                                                 shouldConfirmPasswordBeValid: true)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var confirmPasswordError: String?
        var isButtonEnabled: Bool?
        
        sut.onConfirmPasswordErrorChanged = { confirmPasswordError = $0 }
        sut.onSignUpButtonEnabled = { isEnabled in isButtonEnabled = isEnabled }
        
        sut.onEmailChanged(to: "piczy@gmail.com")
        sut.onPasswordChanged(to: "123456")
        sut.onConfirmPasswordChanged(to: "123456")
        
        XCTAssertNil(confirmPasswordError)
        XCTAssertEqual(isButtonEnabled, true)
    }
    
    @MainActor
    func test_givenNotMatchingPasswords_whenTextFieldsChange_thenConfirmPasswordSetErrorAndButtonIsDisabled() {
        
        let validator = MockCredentialsValidator(shouldEmailBeValid: true,
                                                 shouldPasswordBeValid: true,
                                                 shouldConfirmPasswordBeValid: false)
        let sut = SignUpViewModel(
            onSignUp: {},
            credentialsValidator: validator,
            signUpService: MockSignUpServiceForTest(result: .success(SignUpResponse(token: "piczyToken")))
        )
        
        var confirmPasswordError: String?
        var isButtonEnabled: Bool?
        
        sut.onConfirmPasswordErrorChanged = { confirmPasswordError = $0 }
        sut.onSignUpButtonEnabled = { isEnabled in isButtonEnabled = isEnabled }
        
        sut.onEmailChanged(to: "piczy@gmail.com")
        sut.onPasswordChanged(to: "123456")
        sut.onConfirmPasswordChanged(to: "654321")
        
        XCTAssertEqual(confirmPasswordError, "Passwords do not match")
        XCTAssertEqual(isButtonEnabled, false)
    }
}
