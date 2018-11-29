//
//  GameCenterManageable.swift
//  Conjugar
//
//  Created by Joshua Adams on 11/26/18.
//  Copyright © 2018 Josh Adams. All rights reserved.
//

import Foundation

protocol GameCenterManageable {
  var isAuthenticated: Bool { get set }
  func authenticate(analyticsService: AnalyticsService?, completion: ((Bool) -> Void)?)
  func reportScore(_ score: Int)
  func showLeaderboard()
}
