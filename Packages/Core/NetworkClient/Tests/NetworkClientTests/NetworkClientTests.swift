import XCTest
@testable import NetworkClient

final class NetworkClientTests: XCTestCase {
    
    func test_givenValidURLAndMockResponse_whenGetRequestSuccess_thenReturnsExpectedUserModel() {
        let mockSession = MockURLSession()
        
        mockSession.data = """
            { 
                "email": "piczy@gmail.com", 
                "password": "123456" 
            }
            """.data(using: .utf8)
        
        // Simulate a success HTTP 200 response
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://unsplash.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let client = NetworkClient(urlSession: mockSession)
        let url = URL(string: "https://unsplash.com")!
        
        // Check the GET request result
        client.get(from: url) { result in
            switch result {
            case .success(let data):
                let model = try? JSONDecoder().decode(UserModel.self, from: data)
                XCTAssertEqual(model, UserModel(email: "piczy@gmail.com", password: "123456"))
            case .failure:
                XCTFail("GET failure")
            }
        }
    }
    
    func test_givenMockErrorResponse_whenGetRequestFails_thenReturnsServerErrorStatusCode() {
        let mockSession = MockURLSession()
        
        // Simulate empty data response
        mockSession.data = Data()
        
        // Simulate 404 status code
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://unsplash.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        let client = NetworkClient(urlSession: mockSession)
        let url = URL(string: "https://unsplash.com")!
        
        client.get(from: url) { result in
            switch result {
            case .failure(let error):
                // Check if the .serverError is 404 status code
                if case .serverError(let code) = error {
                    XCTAssertEqual(code, 404)
                } else {
                    XCTFail("Expected Server Error")
                }
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func test_givenEmptyData_whenGetRequestSuccess_thenReturnsNoDataError() {
        let mockSession = MockURLSession()
        
        // Simulate an empty HTTP response
        mockSession.data = nil
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://unsplash.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let client = NetworkClient(urlSession: mockSession)
        let url = URL(string: "https://unsplash.com")!
        
        client.get(from: url) { result in
            switch result {
            case .failure(let error):
                if case .noData = error {
                } else {
                    XCTFail("Expected noData error")
                }
            case .success:
                XCTFail("Expected failure")
            }
        }
    }
    
    func test_givenValidURLAndMockResponse_whenPostRequestSuccess_thenReturnsExpectedUserModel() {
        let mockSession = MockURLSession()
        
        // Mock JSON response data
        mockSession.data = """
            { 
                "email": "piczy@gmail.com", 
                "password": "123456" 
            }
            """.data(using: .utf8)
        
        // Simulate a success HTTP 200 response
        mockSession.response = HTTPURLResponse(
            url: URL(string: "https://unsplash.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let client = NetworkClient(urlSession: mockSession)
        let url = URL(string: "https://unsplash.com")!
        let body = UserModel(email: "piczy@gmail.com", password: "123456")
        let headers = ["Authorization": "Bearer token"]
        
        // Check the POST request result
        client.post(to: url, body: body, headers: headers) { result in
            switch result {
            case .success(let data):
                let model = try? JSONDecoder().decode(UserModel.self, from: data)
                XCTAssertEqual(model, body)
            case .failure:
                XCTFail("POST failure")
            }
        }
    }
}
