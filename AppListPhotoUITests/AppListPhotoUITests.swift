//
//  AppListPhotoUITests.swift
//  AppListPhotoUITests
//
//  Created by đào sơn on 22/11/25.
//

import XCTest

final class AppListPhotoUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UITestMode"]
        app.launch()
    }

    func testSearchAndLoadMore() throws {
        let searchField = app.textFields["searchTextField"]
        XCTAssertTrue(searchField.exists)

        // Input text to text field
        searchField.tap()
        searchField.typeText("Jar")
        app.tap()

        // Check first item
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))

        // scroll to load more
        let table = app.tables.element(boundBy: 0)
        table.swipeUp()
        table.swipeUp()

        // check last cell existed
        let lastIndex = table.cells.count - 1
        let lastCell = table.cells.element(boundBy: lastIndex)
        XCTAssertTrue(lastCell.waitForExistence(timeout: 5))
    }

    func testPullToRefresh() throws {
        let table = app.tables.element(boundBy: 0)
        table.swipeDown() // pull to refresh

        // Check first item
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
    }
}
