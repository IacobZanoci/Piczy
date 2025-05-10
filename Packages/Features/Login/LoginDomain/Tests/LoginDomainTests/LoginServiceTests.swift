import XCTest
@testable import LoginDomain
@testable import NetworkClient

final class LoginServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var networkClient: MockNetworkClient!
    private var sut: MockLoginService!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        networkClient = MockNetworkClient()
        sut = MockLoginService(networkClient: networkClient)
    }
    
    override func tearDown() {
        networkClient = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    @MainActor
    func test_givenValidCredentials_whenLoginSucceeds_thenReturnsExpectedToken() {
        let request = LoginRequest(email: "piczy@gmail.com", password: "123456")
        
        sut.signIn(request: request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.token, "piczyToken")
            case .failure:
                XCTFail()
            }
        }
    }
    
    @MainActor
    func test_givenInvalidCredentials_whenLoginFails_thenReturnsError() {
        let request = LoginRequest(email: "yzcip@gmail.com", password: "654321")
        
        sut.signIn(request: request) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}
