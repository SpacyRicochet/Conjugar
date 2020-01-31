//
//  InfoCell.swift
//  Conjugar
//
//  Created by Joshua Adams on 7/1/17.
//  Copyright © 2017 Josh Adams. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
  static let identifier = "InfoCell"

  @UsesAutoLayout
  var heading: UILabel = {
    let label = UILabel()
    label.textColor = Colors.yellow
    label.font = Fonts.boldBody
    return label
  }()

  required init?(coder aDecoder: NSCoder) {
    NSCoder.fatalErrorNotImplemented()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = Colors.black
    addSubview(heading)

    NSLayoutConstraint.activate([
      heading.centerXAnchor.constraint(equalTo: centerXAnchor),
      heading.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  func configure(heading: String) {
    self.heading.text = heading
  }
}
