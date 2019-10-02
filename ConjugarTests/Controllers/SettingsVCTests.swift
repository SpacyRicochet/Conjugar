//
//  SettingsVCTests.swift
//  ConjugarTests
//
//  Created by Joshua Adams on 5/1/19.
//  Copyright © 2019 Josh Adams. All rights reserved.
//

import XCTest
import UIKit
@testable import Conjugar

class SettingsVCTests: XCTestCase {
  func testSettings() {
    var analytic = ""
    let settings = Settings(getterSetter: DictionaryGetterSetter())
    settings.userRejectedGameCenter = true
    let gameCenter = TestGameCenter(isAuthenticated: false)
    let analytics = TestAnalyticsService(fire: { fired in analytic = fired })
    let quiz = Quiz(settings: settings, gameCenter: gameCenter, shouldShuffle: false)
    let ratingsCount = 42

    Current = World(
      analytics: analytics,
      reviewPrompter: TestReviewPrompter(),
      gameCenter: gameCenter,
      settings: settings,
      quiz: quiz,
      session: URLSession.stubSession(ratingsCount: ratingsCount)
    )

    let svc = SettingsVC()
    let nc = MockNavigationC(rootViewController: svc)

    XCTAssertNotNil(svc)
    svc.viewWillAppear(true)
    XCTAssert(nc.pushedViewController is SettingsVC)
    XCTAssertEqual(analytic, "visited viewController: \(SettingsVC.self) ")

    XCTAssertEqual(settings.region, .latinAmerica)
    let regionControl = svc.settingsView.regionControl
    regionControl.selectedSegmentIndex = 0
    svc.regionChanged(regionControl)
    XCTAssertEqual(settings.region, .spain)

    XCTAssertEqual(settings.difficulty, .easy)
    let difficultyControl = svc.settingsView.difficultyControl
    difficultyControl.selectedSegmentIndex = 2
    svc.difficultyChanged(difficultyControl)
    XCTAssertEqual(settings.difficulty, .difficult)
    difficultyControl.selectedSegmentIndex = 1
    svc.difficultyChanged(difficultyControl)
    XCTAssertEqual(settings.difficulty, .moderate)

    XCTAssertEqual(settings.secondSingularBrowse, .tu)
    let browseVosControl = svc.settingsView.browseVosControl
    browseVosControl.selectedSegmentIndex = 2
    svc.browseVosChanged(browseVosControl)
    XCTAssertEqual(settings.secondSingularBrowse, .both)
    browseVosControl.selectedSegmentIndex = 1
    svc.browseVosChanged(browseVosControl)
    XCTAssertEqual(settings.secondSingularBrowse, .vos)

    XCTAssertEqual(settings.secondSingularQuiz, .tu)
    let quizVosControl = svc.settingsView.quizVosControl
    quizVosControl.selectedSegmentIndex = 1
    svc.quizVosChanged(quizVosControl)
    XCTAssertEqual(settings.secondSingularQuiz, .vos)

    XCTAssertFalse(gameCenter.isAuthenticated)
    svc.authenticate()
    XCTAssert(gameCenter.isAuthenticated)
  }
}
