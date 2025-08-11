//
//  NetworkServiceTests.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
@testable import TVMazeApp

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }

    func testSuccessfulFetch() async throws {
        // Given
        let expectedShow = Show(
            id: 1,
            name: "Test Show",
            genres: ["Drama"],
            schedule: nil,
            image: nil,
            summary: "Test summary",
            rating: nil,
            embedded: nil
        )

        let jsonData = """
        {
            "id": 1,
            "name": "Test Show",
            "genres": ["Drama"],
            "summary": "Test summary"
        }
        """.data(using: .utf8)!

        mockSession.mockData = jsonData
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.tvmaze.com/shows")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When
        let result: Show = try await networkService.fetch(APIEndpoint.Shows.list(page: 0))

        // Then
        XCTAssertEqual(result.id, expectedShow.id)
        XCTAssertEqual(result.name, expectedShow.name)
        XCTAssertEqual(result.genres, expectedShow.genres)
    }

    func testHTTPError() async {
        // Given
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.tvmaze.com/shows")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then
        do {
            let _: [Show] = try await networkService.fetch(APIEndpoint.Shows.list(page: 0))
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            switch error {
            case .httpError(let statusCode):
                XCTAssertEqual(statusCode, 404)
            default:
                XCTFail("Wrong error type")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testDecodingError() async {
        // Given
        let invalidJSONData = "invalid json".data(using: .utf8)!
        mockSession.mockData = invalidJSONData
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.tvmaze.com/shows")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then
        do {
            let _: [Show] = try await networkService.fetch(APIEndpoint.Shows.list(page: 0))
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            switch error {
            case .decodingError:
                break // Expected
            default:
                XCTFail("Wrong error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
