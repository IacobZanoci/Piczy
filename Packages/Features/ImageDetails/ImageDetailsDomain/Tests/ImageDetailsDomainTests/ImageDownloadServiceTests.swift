//
//  ImageDownloadServiceTests.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 29.06.2025.
//

import XCTest
@testable import ImageDetailsDomain

final class ImageDownloadServiceTests: XCTestCase {
    
    // MARK: - Test Setup
    
    var sut: MockImageDownloadService!
    
    override func setUp() {
        super.setUp()
        sut = MockImageDownloadService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    @MainActor
    func test_givenValidURL_whenDownloadImage_thenReturnsLocalFilePath() {
        let expectation = expectation(description: "Download should succeed")
        
        let expectedURL = URL(fileURLWithPath: "/mock/path/image.jpg")
        sut.shouldSucceed = true
        sut.mockFilePath = expectedURL
        
        sut.downloadImage(from: URL(string: "https://valid-url.com/image.jpg")!) { result in
            switch result {
            case .success(let fileURL):
                XCTAssertEqual(fileURL.path, expectedURL.path)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
    
    @MainActor
    func test_givenInvalidURL_whenDownloadImage_thenFailsWithBadURLError() {
        let expectation = expectation(description: "Download should fail with invalid URL")
        sut.shouldSucceed = false
        sut.mockError = .invalidURL
        
        sut.downloadImage(from: URL(string: "invalid-url")!) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                if case .invalidURL = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected ImageDownloadError.invalidURL, but got \(error)")
                }
            }
        }
        waitForExpectations(timeout: 0.1)
    }
    
    @MainActor
    func test_givenNetworkTimeout_whenDownloadImage_thenFailsWithTimeoutError() {
        let expectation = expectation(description: "Download should fail with timeout")
        sut.shouldSucceed = false
        
        sut.downloadImage(from: URL(string: "https://timeout-url.com/image.jpg")!) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                if case .networkTimeout = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected ImageDownloadError.networkTimeout, but got \(error)")
                }
            }
        }
        waitForExpectations(timeout: 0.1)
    }
}
