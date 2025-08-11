//
//  APIEndpointTests.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
import Combine
import SwiftData
import LocalAuthentication
@testable import TVMazeApp

// MARK: - Network Layer Tests

class APIEndpointTests: XCTestCase {

    func testShowsListEndpoint() throws {
        let endpoint = APIEndpoint.Shows.list(page: 0)
        let url = try endpoint.url()

        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api.tvmaze.com")
        XCTAssertEqual(url.path, "/shows")
        XCTAssertTrue(url.query?.contains("page=0") == true)
    }

    func testShowsSearchEndpoint() throws {
        let endpoint = APIEndpoint.Shows.search(query: "breaking bad")
        let url = try endpoint.url()

        XCTAssertEqual(url.path, "/search/shows")
        XCTAssertTrue(url.query?.contains("q=breaking%20bad") == true)
    }

    func testShowsEpisodesEndpoint() throws {
        let endpoint = APIEndpoint.Shows.episodes(showId: 123)
        let url = try endpoint.url()

        XCTAssertEqual(url.path, "/shows/123/episodes")
    }

    func testEpisodeDetailsEndpoint() throws {
        let endpoint = APIEndpoint.Episodes.details(id: 456)
        let url = try endpoint.url()

        XCTAssertEqual(url.path, "/episodes/456")
    }
}
