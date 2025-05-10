import XCTest
@testable import SignUpDomain
@testable import SignUpPresentation
@testable import NetworkClient

final class SignUpServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var networkClient: MockNetworkClient!
    private var credentialsValidator: MockCredentialsValidator!
    private var sut: MockSignUpService!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        networkClient = MockNetworkClient()
        sut = MockSignUpService(networkClient: networkClient)
    }
    
    override func tearDown() {
        networkClient = nil
        credentialsValidator = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func test_givenValidCredentials_whenSignUp_thenReturnsToken() {
        let request = SignUpRequest(email: "newPiczy@gmail.com",
                                    password: "123456",
                                    confirmPassword: "123456")
        
        sut.signUp(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.token, "piczyToken")
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_givenDuplicateEmail_whenSignUp_thenReturnError() {
        let request = SignUpRequest(email: "piczy@gmail.com",
                                    password: "123456",
                                    confirmPassword: "123456")
        
        sut.signUp(request: request) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .emailAlreadyExists)
            }
        }
    }
}
