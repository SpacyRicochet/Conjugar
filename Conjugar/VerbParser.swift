//
//  VerbParser.swift
//  Conjugar
//
//  Created by Joshua Adams on 4/30/17.
//  Copyright (c) 2017 Josh Adams. All rights reserved.
//

import Foundation

class VerbParser: NSObject, XMLParserDelegate {
  private var parser: XMLParser?
  private var buffer = ""
  private let verbTag = "verb"
  private var verbs: [String: [String: String]] = [:]
  private var currentVerb = ""
  private var currentConjugations: [String: String] = [:]
  static let parseError = "An error occurred during XML parsing."
  
  
  override init() {
    // TODO: Spit out list of verbs using VerbLoader to build XML file.
    super.init()
    if let url = Bundle.main.url(forResource: "verbs", withExtension: "xml") {
      parser = XMLParser(contentsOf: url)
      if parser == nil {
        return
      }
      parser?.delegate = self
    }
  }
  
  func parse() -> [String: [String: String]] {
    parser?.parse()
    return verbs
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    if elementName == verbTag {
      if let currentVerb = attributeDict[Tense.infinitivo.rawValue] {
        self.currentVerb = currentVerb
      }
      else {
        fatalError("No infinitive specified.")
      }
      if let ge = attributeDict[Tense.gerundio.rawValue] {
        currentConjugations[Tense.gerundio.rawValue] = ge
      }
      if let po = attributeDict[Tense.participio.rawValue] {
        currentConjugations[Tense.participio.rawValue] = po
      }
      if let tf = attributeDict[Tense.talloFuturo.rawValue] {
        currentConjugations[Tense.talloFuturo.rawValue] = tf
      }
      if let io = attributeDict[PersonNumber.secondSingular.rawValue + Tense.imperativo.rawValue] {
        currentConjugations[PersonNumber.secondSingular.rawValue + Tense.imperativo.rawValue] = io
      }
      
      if let fs = attributeDict[PersonNumber.firstSingular.rawValue + Tense.presenteDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.firstSingular.rawValue + Tense.presenteDeIndicativo.rawValue] = fs
      }
      if let ss = attributeDict[PersonNumber.secondSingular.rawValue + Tense.presenteDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.secondSingular.rawValue + Tense.presenteDeIndicativo.rawValue] = ss
      }
      if let ts = attributeDict[PersonNumber.thirdSingular.rawValue + Tense.presenteDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.thirdSingular.rawValue + Tense.presenteDeIndicativo.rawValue] = ts
      }
      if let fp = attributeDict[PersonNumber.firstPlural.rawValue + Tense.presenteDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.firstPlural.rawValue + Tense.presenteDeIndicativo.rawValue] = fp
      }
      if let sp = attributeDict[PersonNumber.secondPlural.rawValue + Tense.presenteDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.secondPlural.rawValue + Tense.presenteDeIndicativo.rawValue] = sp
      }
      if let tp = attributeDict[PersonNumber.thirdPlural.rawValue + Tense.presenteDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.thirdPlural.rawValue + Tense.presenteDeIndicativo.rawValue] = tp
      }

      if let fs = attributeDict[PersonNumber.firstSingular.rawValue + Tense.preterito.rawValue] {
        currentConjugations[PersonNumber.firstSingular.rawValue + Tense.preterito.rawValue] = fs
      }
      if let ss = attributeDict[PersonNumber.secondSingular.rawValue + Tense.preterito.rawValue] {
        currentConjugations[PersonNumber.secondSingular.rawValue + Tense.preterito.rawValue] = ss
      }
      if let ts = attributeDict[PersonNumber.thirdSingular.rawValue + Tense.preterito.rawValue] {
        currentConjugations[PersonNumber.thirdSingular.rawValue + Tense.preterito.rawValue] = ts
      }
      if let fp = attributeDict[PersonNumber.firstPlural.rawValue + Tense.preterito.rawValue] {
        currentConjugations[PersonNumber.firstPlural.rawValue + Tense.preterito.rawValue] = fp
      }
      if let sp = attributeDict[PersonNumber.secondPlural.rawValue + Tense.preterito.rawValue] {
        currentConjugations[PersonNumber.secondPlural.rawValue + Tense.preterito.rawValue] = sp
      }
      if let tp = attributeDict[PersonNumber.thirdPlural.rawValue + Tense.preterito.rawValue] {
        currentConjugations[PersonNumber.thirdPlural.rawValue + Tense.preterito.rawValue] = tp
      }

      if let fs = attributeDict[PersonNumber.firstSingular.rawValue + Tense.imperfectoDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.firstSingular.rawValue + Tense.imperfectoDeIndicativo.rawValue] = fs
      }
      if let ss = attributeDict[PersonNumber.secondSingular.rawValue + Tense.imperfectoDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.secondSingular.rawValue + Tense.imperfectoDeIndicativo.rawValue] = ss
      }
      if let ts = attributeDict[PersonNumber.thirdSingular.rawValue + Tense.imperfectoDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.thirdSingular.rawValue + Tense.imperfectoDeIndicativo.rawValue] = ts
      }
      if let fp = attributeDict[PersonNumber.firstPlural.rawValue + Tense.imperfectoDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.firstPlural.rawValue + Tense.imperfectoDeIndicativo.rawValue] = fp
      }
      if let sp = attributeDict[PersonNumber.secondPlural.rawValue + Tense.imperfectoDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.secondPlural.rawValue + Tense.imperfectoDeIndicativo.rawValue] = sp
      }
      if let tp = attributeDict[PersonNumber.thirdPlural.rawValue + Tense.imperfectoDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.thirdPlural.rawValue + Tense.imperfectoDeIndicativo.rawValue] = tp
      }
      
      if let fs = attributeDict[PersonNumber.firstSingular.rawValue + Tense.presenteDeSubjuntivo.rawValue] {
        currentConjugations[PersonNumber.firstSingular.rawValue + Tense.presenteDeSubjuntivo.rawValue] = fs
      }
      if let ss = attributeDict[PersonNumber.secondSingular.rawValue + Tense.presenteDeSubjuntivo.rawValue] {
        currentConjugations[PersonNumber.secondSingular.rawValue + Tense.presenteDeSubjuntivo.rawValue] = ss
      }
      if let ts = attributeDict[PersonNumber.thirdSingular.rawValue + Tense.presenteDeSubjuntivo.rawValue] {
        currentConjugations[PersonNumber.thirdSingular.rawValue + Tense.presenteDeSubjuntivo.rawValue] = ts
      }
      if let fp = attributeDict[PersonNumber.firstPlural.rawValue + Tense.presenteDeSubjuntivo.rawValue] {
        currentConjugations[PersonNumber.firstPlural.rawValue + Tense.presenteDeSubjuntivo.rawValue] = fp
      }
      if let sp = attributeDict[PersonNumber.secondPlural.rawValue + Tense.presenteDeSubjuntivo.rawValue] {
        currentConjugations[PersonNumber.secondPlural.rawValue + Tense.presenteDeSubjuntivo.rawValue] = sp
      }
      if let tp = attributeDict[PersonNumber.thirdPlural.rawValue + Tense.presenteDeSubjuntivo.rawValue] {
        currentConjugations[PersonNumber.thirdPlural.rawValue + Tense.presenteDeSubjuntivo.rawValue] = tp
      }

      if let fs = attributeDict[PersonNumber.firstSingular.rawValue + Tense.futuroDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.firstSingular.rawValue + Tense.futuroDeIndicativo.rawValue] = fs
      }
      if let ss = attributeDict[PersonNumber.secondSingular.rawValue + Tense.futuroDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.secondSingular.rawValue + Tense.futuroDeIndicativo.rawValue] = ss
      }
      if let ts = attributeDict[PersonNumber.thirdSingular.rawValue + Tense.futuroDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.thirdSingular.rawValue + Tense.futuroDeIndicativo.rawValue] = ts
      }
      if let fp = attributeDict[PersonNumber.firstPlural.rawValue + Tense.futuroDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.firstPlural.rawValue + Tense.futuroDeIndicativo.rawValue] = fp
      }
      if let sp = attributeDict[PersonNumber.secondPlural.rawValue + Tense.futuroDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.secondPlural.rawValue + Tense.futuroDeIndicativo.rawValue] = sp
      }
      if let tp = attributeDict[PersonNumber.thirdPlural.rawValue + Tense.futuroDeIndicativo.rawValue] {
        currentConjugations[PersonNumber.thirdPlural.rawValue + Tense.futuroDeIndicativo.rawValue] = tp
      }

      if let fs = attributeDict[PersonNumber.firstSingular.rawValue + Tense.condicional.rawValue] {
        currentConjugations[PersonNumber.firstSingular.rawValue + Tense.condicional.rawValue] = fs
      }
      if let ss = attributeDict[PersonNumber.secondSingular.rawValue + Tense.condicional.rawValue] {
        currentConjugations[PersonNumber.secondSingular.rawValue + Tense.condicional.rawValue] = ss
      }
      if let ts = attributeDict[PersonNumber.thirdSingular.rawValue + Tense.condicional.rawValue] {
        currentConjugations[PersonNumber.thirdSingular.rawValue + Tense.condicional.rawValue] = ts
      }
      if let fp = attributeDict[PersonNumber.firstPlural.rawValue + Tense.condicional.rawValue] {
        currentConjugations[PersonNumber.firstPlural.rawValue + Tense.condicional.rawValue] = fp
      }
      if let sp = attributeDict[PersonNumber.secondPlural.rawValue + Tense.condicional.rawValue] {
        currentConjugations[PersonNumber.secondPlural.rawValue + Tense.condicional.rawValue] = sp
      }
      if let tp = attributeDict[PersonNumber.thirdPlural.rawValue + Tense.condicional.rawValue] {
        currentConjugations[PersonNumber.thirdPlural.rawValue + Tense.condicional.rawValue] = tp
      }
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    // Shouldn't need. Will probably delete this method if possible.
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == verbTag {
      verbs[currentVerb] = currentConjugations
      currentConjugations = [:]
    }
  }
}
