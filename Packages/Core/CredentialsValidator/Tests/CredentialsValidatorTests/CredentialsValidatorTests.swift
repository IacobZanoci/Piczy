import XCTest
@testable import CredentialsValidator

final class CredentialsValidatorTests: XCTestCase {
    
    var sut: CredentialsValidator!
    
    override func setUp() {
        super.setUp()
        sut = CredentialsValidator()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_givenValidEmail_whenValidate_thenReturnTrue() {
        XCTAssertTrue(sut.isEmailValid("piczy.user@gmail.com"))
    }
    
    func test_givenInvalidEmailWithTwoDoubleAtSymbols_whenValidate_thenReturnFalse() {
        XCTAssertFalse(sut.isEmailValid("piczy.user@@gmail.com"))
    }
    
    func test_givenInvalidEmailWithShortDomainExtension_whenValidate_thenReturnFalse() {
        XCTAssertFalse(sut.isEmailValid("piczy.user@gmail.c"))
    }
    
    func test_givenInvalidEmailWithMissingAtSymbol_whenValidate_thenReturnFalse() {
        XCTAssertFalse(sut.isEmailValid("piczy.user.gmail.com"))
    }
    
    func test_givenValidPasswordWithMinimumNumberOfCharactersOfSix_whenValidate_thenReturnTrue() {
        XCTAssertTrue(sut.isPasswordValid("123456"))
    }
    
    func test_givenValidPasswordWithSixOrMoreCharacters_whenValidate_thenReturnTrue() {
        XCTAssertTrue(sut.isPasswordValid("123456789"))
    }
    
    func test_givenInvalidPasswordShorterThanMinimumNumberOfCharactersOfSix_whenValidate_thenReturnFalse() {
        XCTAssertFalse(sut.isPasswordValid("12345"))
    }
}
