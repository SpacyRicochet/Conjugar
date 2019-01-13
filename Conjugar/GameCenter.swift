//
//  GameCenter.swift
//  Conjugar
//
//  Created by Joshua Adams on 6/26/17.
//  Copyright © 2017 Josh Adams. All rights reserved.
//

import GameKit

class GameCenter: NSObject, GameCenterable, GKGameCenterControllerDelegate {
  static let shared = GameCenter()
  var isAuthenticated = false
  private let localPlayer = GKLocalPlayer.localPlayer()
  private var leaderboardIdentifier = ""

  private override init() {}

  func authenticate(analyticsService: AnalyticsServiceable?, completion: ((Bool) -> Void)? = nil) {
    localPlayer.authenticateHandler = { viewController, error in
      if let viewController = viewController, let topController = UIApplication.topViewController() {
        topController.present(viewController, animated: true, completion: nil)
      } else if self.localPlayer.isAuthenticated {
        //print("AUTHENTICATED displayName: \(self.localPlayer.displayName) alias: \(self.localPlayer.alias) playerID: \(self.localPlayer.playerID)")
        analyticsService?.recordGameCenterAuth()
        self.isAuthenticated = true
        SoundPlayer.play(.applause1)
        self.localPlayer.loadDefaultLeaderboardIdentifier { identifier, error in
          self.leaderboardIdentifier = identifier ?? "ERROR"
          //print("identifier: \(self.leaderboardIdentifier)")
        }
        completion?(true)
      } else {
        SoundPlayer.play(.sadTrombone)
        UIAlertController.showMessage("Game Center authentication failed. This can happen if you cancel authentication or if your iPhone is not already signed into Game Center. Try launching the Settings app, tapping Game Center, signing in, and relaunching Conjugar.", title: "😰", okTitle: "Got It")
        self.isAuthenticated = false
        completion?(false)
      }
    }
  }

  func reportScore(_ score: Int) {
    if !isAuthenticated {
      return
    }
    let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier)
    gkScore.value = Int64(score)
    GKScore.report([gkScore]) { error in
      if error == nil {
        let delay: TimeInterval = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
          self.showLeaderboard()
        })
      }
    }
  }

  func showLeaderboard() {
    if !isAuthenticated {
      return
    }
    let gcViewController = GKGameCenterViewController()
    gcViewController.gameCenterDelegate = self
    gcViewController.viewState = .leaderboards
    gcViewController.leaderboardIdentifier = leaderboardIdentifier
    if let topController = UIApplication.topViewController() {
      topController.present(gcViewController, animated: true, completion: nil)
    }
  }

  func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismiss(animated: true, completion: nil)
  }
}
