//
//  MockFavoritesManagerTests.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
@testable import TVMazeApp

@MainActor
final class MockFavoritesManagerTests: XCTestCase {

    var favoritesManager: MockFavoritesManager!

    override func setUp() {
        super.setUp()
        favoritesManager = MockFavoritesManager()
    }

    override func tearDown() {
        favoritesManager = nil
        super.tearDown()
    }

    func testAddFavorite() {
        // Given
        let show = TestData.sampleShow
        XCTAssertFalse(favoritesManager.isFavorite(show))

        // When
        favoritesManager.addFavorite(show)

        // Then
        XCTAssertTrue(favoritesManager.isFavorite(show))
    }

    func testRemoveFavorite() {
        // Given
        let show = TestData.sampleShow
        favoritesManager.addFavorite(show)
        XCTAssertTrue(favoritesManager.isFavorite(show))

        // When
        favoritesManager.removeFavorite(show)

        // Then
        XCTAssertFalse(favoritesManager.isFavorite(show))
    }

    func testToggleFavorite() {
        // Given
        let show = TestData.sampleShow
        XCTAssertFalse(favoritesManager.isFavorite(show))

        // When - Toggle to favorite
        favoritesManager.toggleFavorite(show)

        // Then
        XCTAssertTrue(favoritesManager.isFavorite(show))

        // When - Toggle back
        favoritesManager.toggleFavorite(show)

        // Then
        XCTAssertFalse(favoritesManager.isFavorite(show))
    }
}
