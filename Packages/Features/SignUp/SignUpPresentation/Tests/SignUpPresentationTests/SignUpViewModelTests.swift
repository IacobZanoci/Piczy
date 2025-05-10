import XCTest
@testable import SignUpPresentation
@testable import SignUpDomain
@testable import NetworkClient
@testable import CredentialsValidator

final class SignUpViewModelTests: XCTestCase {
    
    @MainActor
    func test_givenValidCredentials_whenSignUp_thenTriggersSignUpAction() async {
        
        // Given
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
        
        // When
        sut.onSignUp()
        
        // Then
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(didCallOnSignUp)
    }
    
    @MainActor
    func test_givenDuplicateEmail_whenSignUp_thenSetsEmailError() async {
        
        // Given
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
        
        // When
        sut.onSignUp()
        
        // Then
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(capturedError, "Email already in use")
    }
    
    @MainActor
    func test_givenUnknownError_whenSignUp_thenSetsEmailError() async {
        
        // Given
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
        
        // When
        sut.onSignUp()
        
        // Then
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(capturedError, "Unknown error")
    }
}
