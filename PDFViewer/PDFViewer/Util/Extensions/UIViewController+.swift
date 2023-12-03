//
//  UIViewController+.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import UIKit

extension UIViewController {
  func presentFailAlert(message: String) {
    let okAction = UIAlertAction(title: NameSpace.yes, style: .cancel)
    
    let alert = AlertManager()
      .setTitle(NameSpace.failure)
      .setMessage(message)
      .setAction(okAction)
      .buildAlert()
    
    self.present(alert, animated: true)
  }
}
