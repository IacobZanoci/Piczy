//
//  ImageDetailsServiceTests.swift
//  ImageDetailsDomain
//
//  Created by Iacob Zanoci on 29.06.2025.
//

import XCTest
@testable import ImageDetailsDomain
@testable import NetworkClient

final class ImageDetailsServiceTests: XCTestCase {
    
    // MARK: - Test Setup
    
    private var mockClient: MockNetworkForImageDetails!
    private var sut: ImageDetailsService!
    
    override func setUp() {
        super.setUp()
        mockClient = MockNetworkForImageDetails()
        let mockConfig = UnsplashConfig(
            baseURL: "https://api.unsplash.com",
            accessKey: "mock-access-key"
        )
        sut = ImageDetailsService(networkManager: mockClient, config: mockConfig)
    }
    
    override func tearDown() {
        mockClient = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    @MainActor
    func test_givenValidImageJson_whenFetchPicturesDetails_thenReturnsSuccess() {
        
        let expectation = self.expectation(description: "Success")
        
        let imageJson = """
            {
                "id": "123456",
                "created_at": "2024-12-31T12:34:56+0000",
                "urls": { "regular": "https://unsplash.com/image.jpg" },
                "user": { "name": "Iacob Zanoci" },
                "exif": { "make": "Canon", "model": "EOS 80D" },
                "location": { "city": "Paris", "country": "France" }
            }
            """.data(using: .utf8)!
        
        mockClient.result = .success(imageJson)
        
        sut.fetchPictureDetails(pictureId: "123456") { result in
            switch result {
            case .success(let details):
                XCTAssertEqual(details.id, "123456")
                XCTAssertEqual(details.user.name, "Iacob Zanoci")
                XCTAssertEqual(details.urls.regular, "https://unsplash.com/image.jpg")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
    
    @MainActor
    func test_givenServerReturns404Error_whenFetchPicturesDetails_thenReturnsFailure() {
        
        let expectation = self.expectation(description: "404 Error")
        
        mockClient.result = .failure(.serverError(statusCode: 404))
        
        sut.fetchPictureDetails(pictureId: "notFound") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .serverError(statusCode: 404))
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
    
    @MainActor
    func test_givenDecodingErrorDuringFetchingImageDetails_whenFetchPicturesDetails_thenReturnsFailure() {
        
        let expectation = self.expectation(description: "Decoding Error")
        
        let invalidJson = """
            {
                "id": "1",
                "created_at": "error-date-format"
            }
            """.data(using: .utf8)!
        
        mockClient.result = .success(invalidJson)
        
        sut.fetchPictureDetails(pictureId: "error-json") { result in
            switch result {
            case .success:
                XCTFail("Expected decoding failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .decodingError)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
}
