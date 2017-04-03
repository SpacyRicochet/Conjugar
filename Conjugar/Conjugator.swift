//
//  Conjugator.swift
//  Conjugar
//
//  Created by Joshua Adams on 3/31/17.
//  Copyright © 2017 Josh Adams. All rights reserved.
//

import Foundation

class Conjugator {
  static let defective = "defective"
  static let parent = "parent"
  static let trim = "trim"
  static let stem = "stem"
  
  var verbs: [String: [String: String]] = [:]
  
  init() {
    verbs = VerbLoader.loadVerbs()
  }
  
  func conjugate(infinitive: String, tense: Tense, personNumber: PersonNumber, region: Region = .spain) -> Result<String, ConjugatorError> {
    if infinitive.characters.count < 3 {
      return .failure(.tooShort)
    }
    let index = infinitive.index(infinitive.endIndex, offsetBy: -2)
    let ending = infinitive.substring(from: index)
    if !["ar", "er", "ir"].contains(ending) {
      return .failure(.invalidEnding(ending))
    }
    if (tense == .gerundio || tense == .participio) && personNumber != .none {
      return .failure(.noSuchConjugation(personNumber))
    }
    if (tense != .gerundio && tense != .participio) && personNumber == .none {
      return .failure(.personNumberAbsent(tense))
    }
    
    if verbs[infinitive] == nil {
      let stem = infinitive.substring(to: index)
      var verb:[String: String] = [:]
      if ending == "ar" {
        verb[Conjugator.parent] = "hablar"
        verb[Conjugator.stem] = stem
        verb[Conjugator.trim] = "habl"
      }
      else if ending == "er" {
        verb[Conjugator.parent] = "comer"
        verb[Conjugator.stem] = stem
        verb[Conjugator.trim] = "com"
      }
      else { // if ending == "ir"
        verb[Conjugator.parent] = "subir"
        verb[Conjugator.stem] = stem
        verb[Conjugator.trim] = "sub"
      }
      verbs[infinitive] = verb
    }
    // TODO: Detect defective conjugation and return appropriate error.
    return conjugateRecursively(infinitive: infinitive, tense: tense, personNumber: personNumber, region: region)
  }
  
  private func conjugateRecursively(infinitive: String, tense: Tense, personNumber: PersonNumber, region: Region = .spain) -> Result<String, ConjugatorError> {
    var verb = verbs[infinitive]!
    var modifiedPersonNumber = personNumber
    if personNumber == .secondPlural && region == .latinAmerica {
      modifiedPersonNumber = .thirdPlural
    }
    let conjugationKey = modifiedPersonNumber.rawValue + tense.rawValue
    if let conjugation = verb[conjugationKey] {
      return .success(conjugation)
    }
    else {
      let parentConjugation = conjugateRecursively(infinitive: verb[Conjugator.parent]!, tense: tense, personNumber: personNumber, region: region).value!
      let trim = verb[Conjugator.trim]!
      let stem = verb[Conjugator.stem]!
      var conjugation: String
      if trim == "" {
        conjugation = stem + parentConjugation
      }
      else {
        conjugation = parentConjugation.replaceFirstOccurence(of: trim, with: stem)
      }
      verb[conjugationKey] = conjugation
      verbs[infinitive] = verb
      return .success(conjugation)
    }
  }
}
