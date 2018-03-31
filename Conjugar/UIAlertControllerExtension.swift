//
//  UIAlertControllerExtension.swift
//  Conjugar
//
//  Created by Joshua Adams on 8/19/17.
//  Copyright © 2017 Josh Adams. All rights reserved.
//

import UIKit

extension UIAlertController {
  // See http://stackoverflow.com/a/39975404/2084036 for why this needs to be a class method rather than a class property.
  static func okTitle() -> String { return "OK" }
  
  class func showMessage(_ message: String, title: String, okTitle: String = UIAlertController.okTitle(), handler: ((UIAlertAction) -> Void)? = nil) {
    if let topController = UIApplication.topViewController() {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
      let okAction = UIAlertAction(title: okTitle, style: UIAlertActionStyle.default, handler: handler)
      alertController.addAction(okAction)
      topController.present(alertController, animated: true, completion: nil)
    }
  }
}
