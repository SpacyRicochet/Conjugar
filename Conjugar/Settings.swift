//
//  Settings.swift
//  Conjugar
//
//  Created by Joshua Adams on 11/17/18.
//  Copyright © 2018 Josh Adams. All rights reserved.
//

import Foundation

class Settings {
  static let shared = Settings()

  private var userDefaults: UserDefaults?

  var promptActionCount: Int {
    didSet {
      if let userDefaults = userDefaults, promptActionCount != oldValue {
        userDefaults.set("\(promptActionCount)", forKey: Settings.promptActionCountKey)
      }
    }
  }
  static let promptActionCountKey = "promptActionCount"
  private static let promptActionCountDefault = 0

  var lastReviewPromptDate: Date {
    didSet {
      if let userDefaults = userDefaults, lastReviewPromptDate != oldValue {
        userDefaults.set(formatter.string(from: lastReviewPromptDate), forKey: Settings.lastReviewPromptDateKey)
      }
    }
  }
  static let lastReviewPromptDateKey = "lastReviewPromptDate"
  private static let lastReviewPromptDateDefault = Date(timeIntervalSince1970: 0.0)
  private let formatter = DateFormatter()
  private static let format = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"

  private init() {
    userDefaults = UserDefaults.standard
    formatter.dateFormat = Settings.format

    guard let userDefaults = userDefaults else {
      fatalError("userDefaults was nil.")
    }

    if let promptActionCountString = userDefaults.string(forKey: Settings.promptActionCountKey) {
      promptActionCount = Int((promptActionCountString as NSString).intValue)
    } else {
      promptActionCount = Settings.promptActionCountDefault
      userDefaults.set("\(promptActionCount)", forKey: Settings.promptActionCountKey)
    }

    if let lastReviewPromptDateString = userDefaults.string(forKey: Settings.lastReviewPromptDateKey) {
      lastReviewPromptDate = formatter.date(from: lastReviewPromptDateString) ?? Date()
    } else {
      lastReviewPromptDate = Settings.lastReviewPromptDateDefault
      userDefaults.set(formatter.string(from: lastReviewPromptDate), forKey: Settings.lastReviewPromptDateKey)
    }
  }

  init(customDefaults: [String: Any]) {
    formatter.dateFormat = Settings.format

    if let promptActionCount = customDefaults[Settings.promptActionCountKey] as? Int {
      self.promptActionCount = promptActionCount
    } else {
      promptActionCount = Settings.promptActionCountDefault
    }

    if let lastReviewPromptDate = formatter.date(from: (customDefaults[Settings.lastReviewPromptDateKey] as? String ?? "")) {
      self.lastReviewPromptDate = lastReviewPromptDate
    } else {
      lastReviewPromptDate = Settings.lastReviewPromptDateDefault
    }
  }
}
