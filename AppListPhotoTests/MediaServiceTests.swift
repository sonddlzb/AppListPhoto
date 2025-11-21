//
//  MediaServiceTests.swift
//  MediaServiceTests
//
//  Created by đào sơn on 22/11/25.
//

import XCTest
import Domain
import Platform

final class MediaServiceTests: XCTestCase {
    var mediaUseCase: Domain.MediaUseCase!

    override func setUp() {
        super.setUp()
        mediaUseCase = UseCaseProvider.makeMediaUseCase()
    }

    override func tearDown() {
        mediaUseCase = nil
        super.tearDown()
    }

    func testFetchPhotoList() {
        let expectation = self.expectation(description: "Fetch photos success")
        mediaUseCase.fetchPhotos(page: 1, limit: 100) { result in
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, 100)
                XCTAssertNotNil(photos.first?.author)
            case .failure:
                XCTFail("Not success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
}
