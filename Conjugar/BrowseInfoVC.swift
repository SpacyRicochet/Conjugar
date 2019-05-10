//
//  BrowseInfoVC.swift
//  Conjugar
//
//  Created by Joshua Adams on 7/1/17.
//  Copyright © 2017 Josh Adams. All rights reserved.
//

import UIKit

class BrowseInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoDelegate {
  private var selectedRow = 0
  private var allInfos: [Info] = []
  private var easyModerateInfos: [Info] = []
  private var easyInfos: [Info] = []
  private let settings: Settings
  private let analyticsService: AnalyticsServiceable

  private var currentInfos: [Info] {
    switch browseInfoView.difficultyControl.selectedSegmentIndex {
    case 0:
      return easyInfos
    case 1:
      return easyModerateInfos
    case 2:
      return allInfos
    default:
      fatalError("Invalid UISegmentedControl index.")
    }
  }

  var browseInfoView: BrowseInfoView {
    if let castedView = view as? BrowseInfoView {
      return castedView
    } else {
      fatalError(fatalCastMessage(view: BrowseInfoView.self))
    }
  }

  init(settings: Settings, analyticsService: AnalyticsServiceable) {
    self.settings = settings
    self.analyticsService = analyticsService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    UIViewController.fatalErrorNotImplemented()
  }

  override func loadView() {
    let browseInfoView: BrowseInfoView
    browseInfoView = BrowseInfoView(frame: UIScreen.main.bounds)
    browseInfoView.difficultyControl.addTarget(self, action: #selector(BrowseInfoVC.difficultyChanged(_:)), for: .valueChanged)
    browseInfoView.setupTable(dataSource: self, delegate: self)
    navigationItem.titleView = UILabel.titleLabel(title: "Info")
    easyInfos = Info.infos.filter {
      $0.difficulty == .easy
    }
    easyModerateInfos = Info.infos.filter {
      $0.difficulty == .easy || $0.difficulty == .moderate
    }
    allInfos = Info.infos
    view = browseInfoView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateDifficultyControl()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    analyticsService.recordVisitation(viewController: "\(BrowseInfoVC.self)")
  }

  private func updateDifficultyControl() {
    switch settings.infoDifficulty {
    case .easy:
      browseInfoView.difficultyControl.selectedSegmentIndex = 0
    case .moderate:
      browseInfoView.difficultyControl.selectedSegmentIndex = 1
    case .difficult:
      browseInfoView.difficultyControl.selectedSegmentIndex = 2
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentInfos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier) as? InfoCell else {
      fatalError("Could not dequeue \(InfoCell.self).")
    }
    guard let decodedString = currentInfos[indexPath.row].heading.removingPercentEncoding else {
      fatalError("Could not decode string.")
    }
    cell.configure(heading: decodedString)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedRow = (indexPath as NSIndexPath).row
    tableView.deselectRow(at: indexPath, animated: false)
    showInfo()
  }

  func infoSelectionDidChange(newHeading: String) {
    for i in 0 ..< Info.infos.count {
      if currentInfos[i].heading.lowercased() == newHeading.lowercased() {
        selectedRow = i
        break
      }
    }
    showInfo()
  }

  private func showInfo() {
    let infoVC = InfoVC(analyticsService: analyticsService, infoString: currentInfos[selectedRow].infoString, infoDelegate: self)
    navigationController?.pushViewController(infoVC, animated: true)
  }

  @objc func difficultyChanged(_ sender: UISegmentedControl) {
    let index = browseInfoView.difficultyControl.selectedSegmentIndex
    if index == 0 {
      settings.infoDifficulty = .easy
    } else if index == 1 {
      settings.infoDifficulty = .moderate
    } else /* index == 2 */ {
      settings.infoDifficulty = .difficult
    }
    browseInfoView.table.reloadData()
  }
}
