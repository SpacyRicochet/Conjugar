//
//  VerbVC.swift
//  Conjugar
//
//  Created by Joshua Adams on 4/10/17.
//  Copyright © 2017 Josh Adams. All rights reserved.
//

import Foundation
import UIKit

class VerbVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var verb: String = ""
  
  override func viewDidLoad() {
    verbView.participio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapSpanish(_:))))
    verbView.raizFutura.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapSpanish(_:))))
    verbView.gerundio.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapSpanish(_:))))
    verbView.translation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapEnglish(_:))))
    verbView.defectivo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapEnglish(_:))))
    guard verb != "" else { fatalError() }
    initNavigationItemTitleView()
    let translationResult = Conjugator.sharedInstance.conjugate(infinitive: verb, tense: .translation, personNumber: .none)
    switch translationResult {
    case let .success(value):
      verbView.translation.text = value
    default:
      fatalError()
    }
    let gerundioResult = Conjugator.sharedInstance.conjugate(infinitive: verb, tense: .gerundio, personNumber: .none)
    switch gerundioResult {
    case let .success(value):
      verbView.gerundio.attributedText = value.conjugatedString
    default:
      fatalError()
    }
    let participioResult = Conjugator.sharedInstance.conjugate(infinitive: verb, tense: .participio, personNumber: .none)
    switch participioResult {
    case let .success(value):
      verbView.participio.attributedText = value.conjugatedString
    default:
      fatalError()
    }
    let raizFuturaResult = Conjugator.sharedInstance.conjugate(infinitive: verb, tense: .raizFutura, personNumber: .none)
    switch raizFuturaResult {
    case let .success(value):
      verbView.raizFutura.attributedText = value.conjugatedString + NSAttributedString(string: "-")
    default:
      fatalError()
    }
    if Conjugator.sharedInstance.isDefective(infinitive: verb) {
      verbView.defectivo.text = "Defective"
    }
    else {
      verbView.defectivo.text = "Not Defective"
    }
    
    let verbType = Conjugator.sharedInstance.verbType(infinitive: verb)
    switch verbType {
    case .regularAr:
      verbView.parentOrType.text = "Regular AR"
    case .regularEr:
      verbView.parentOrType.text = "Regular ER"
    case .regularIr:
      verbView.parentOrType.text = "Regular IR"
    case .irregular:
      guard let parent = Conjugator.sharedInstance.parent(infinitive: verb) else { fatalError() }
      if Conjugator.baseVerbs.contains(parent) {
        verbView.parentOrType.text = "Irregular"
      }
      else {
        verbView.parentOrType.text = "Irreg. ☛ \(parent)"
      }
    }
  }
  
  var verbView: VerbView {
    return view as! VerbView
  }
  
  override func loadView() {
    let verbView: VerbView
    if #available(iOS 11.0, *) {
      verbView = VerbView(frame: UIScreen.main.bounds)
    }
    else {
      verbView = VerbView(frame: UIScreen.main.bounds, safeBottomInset: 49)
    }
    verbView.setupTable(dataSource: self, delegate: self)
    view = verbView
  }
  
  private func initNavigationItemTitleView() {
    let titleLabel = UILabel.titleLabel(title: verb.capitalized)
    navigationItem.titleView = titleLabel
    titleLabel.isUserInteractionEnabled = true
    titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapSpanish(_:))))
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 138
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = indexPath.row
    var personNumber: PersonNumber = .none
    let personNumbers: [PersonNumber] =  [.firstSingular, .secondSingular, .thirdSingular, .firstPlural, .secondPlural, .thirdPlural]
    var tense: Tense
    switch row {
    case 0:
      tense = .presenteDeIndicativo
    case 1...6:
      tense = .presenteDeIndicativo
      personNumber = personNumbers[row - 1]
    case 7:
      tense = .preterito
    case 8...13:
      tense = .preterito
      personNumber = personNumbers[row - 8]
    case 14:
      tense = .imperfectoDeIndicativo
    case 15...20:
      tense = .imperfectoDeIndicativo
      personNumber = personNumbers[row - 15]
    case 21:
      tense = .futuroDeIndicativo
    case 22...27:
      tense = .futuroDeIndicativo
      personNumber = personNumbers[row - 22]
    case 28:
      tense = .condicional
    case 29...34:
      tense = .condicional
      personNumber = personNumbers[row - 29]
    case 35:
      tense = .presenteDeSubjuntivo
    case 36...41:
      tense = .presenteDeSubjuntivo
      personNumber = personNumbers[row - 36]
    case 42:
      tense = .futuroDeSubjuntivo
    case 43...48:
      tense = .futuroDeSubjuntivo
      personNumber = personNumbers[row - 43]
    case 49:
      tense = .imperfectoDeSubjuntivo1
    case 50...55:
      tense = .imperfectoDeSubjuntivo1
      personNumber = personNumbers[row - 50]
    case 56:
      tense = .imperfectoDeSubjuntivo2
    case 57...62:
      tense = .imperfectoDeSubjuntivo2
      personNumber = personNumbers[row - 57]
    case 63:
      tense = .imperativoPositivo
    case 64...68:
      tense = .imperativoPositivo
      personNumber = personNumbers[row - 63]
    case 69:
      tense = .imperativoNegativo
    case 70...74:
      tense = .imperativoNegativo
      personNumber = personNumbers[row - 69]
    case 75:
      tense = .perfectoDeIndicativo
    case 76...81:
      tense = .perfectoDeIndicativo
      personNumber = personNumbers[row - 76]
    case 82:
      tense = .preteritoAnterior
    case 83...88:
      tense = .preteritoAnterior
      personNumber = personNumbers[row - 83]
    case 89:
      tense = .pluscuamperfectoDeIndicativo
    case 90...95:
      tense = .pluscuamperfectoDeIndicativo
      personNumber = personNumbers[row - 90]
    case 96:
      tense = .futuroPerfecto
    case 97...102:
      tense = .futuroPerfecto
      personNumber = personNumbers[row - 97]
    case 103:
      tense = .condicionalCompuesto
    case 104...109:
      tense = .condicionalCompuesto
      personNumber = personNumbers[row - 104]
    case 110:
      tense = .perfectoDeSubjuntivo
    case 111...116:
      tense = .perfectoDeSubjuntivo
      personNumber = personNumbers[row - 111]
    case 117:
      tense = .pluscuamperfectoDeSubjuntivo1
    case 118...123:
      tense = .pluscuamperfectoDeSubjuntivo1
      personNumber = personNumbers[row - 118]
    case 124:
      tense = .pluscuamperfectoDeSubjuntivo2
    case 125...130:
      tense = .pluscuamperfectoDeSubjuntivo2
      personNumber = personNumbers[row - 125]
    case 131:
      tense = .futuroPerfectoDeSubjuntivo
    case 132...137:
      tense = .futuroPerfectoDeSubjuntivo
      personNumber = personNumbers[row - 132]
    default:
      fatalError()
    }
    if personNumber == .none {
      let cell = tableView.dequeueReusableCell(withIdentifier: TenseCell.identifier) as! TenseCell
      cell.configure(tense: tense.titleCaseName)
      return cell
    }
    else {
      let cell = tableView.dequeueReusableCell(withIdentifier: ConjugationCell.identifier) as! ConjugationCell
      var conjugation = ""
      let conjugationResult = Conjugator.sharedInstance.conjugate(infinitive: verb, tense: tense, personNumber: personNumber)
      switch conjugationResult {
      case let .success(value):
        conjugation = value
      default:
        fatalError()
      }
      cell.configure(tense: tense, personNumber: personNumber, conjugation: conjugation)
      return cell
    }
  }
  
  @objc func tapSpanish(_ sender: UITapGestureRecognizer) {
    if let label = sender.view as? UILabel {
      Utterer.utter(label.attributedText?.string ?? label.text!)
    }
  }
  
  @objc func tapEnglish(_ sender: UITapGestureRecognizer) {
    if let label = sender.view as? UILabel {
      Utterer.utter(label.attributedText?.string ?? label.text!, locale: "en-US")
    }
  }
}