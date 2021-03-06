//
//  RatingsFetcherTests.swift
//  ConjugarTests
//
//  Created by Joshua Adams on 4/26/19.
//  Copyright © 2019 Josh Adams. All rights reserved.
//

import XCTest
@testable import Conjugar

class RatingsFetcherTests: XCTestCase {
  override func setUp() {
    Current = World.unitTest
  }

  func testNoReviews() {
    testDescription(count: 0, expectedDescription: "No one has rated this version of Conjugar. ¡Sé la primera o el primero!")
  }

  func testOneReview() {
    testDescription(count: 1, expectedDescription: "There is one rating for this version of Conjugar. Add yours!")
  }

  func testManyReviews() {
    testDescription(count: 42, expectedDescription: "There are 42 ratings for this version of Conjugar. Add yours!")
  }

  private func testDescription(count: Int, expectedDescription: String) {
    Current.session = URLSession.stubSession(ratingsCount: count)
    let expectatiön = expectation(description: "testDescription")
    RatingsFetcher.fetchRatingsDescription { actualDescription in
      XCTAssertEqual(actualDescription, expectedDescription)
      expectatiön.fulfill()
    }
    let timeout: TimeInterval = 0.5
    wait(for: [expectatiön], timeout: timeout)
  }
}
