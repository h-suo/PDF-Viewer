//
//  AlertManager.swift
//  PDFViewer
//
//  Created by Erick on 2023/11/21.
//

import UIKit

struct AlertManager {
  
  // MARK: - Private Property
  private var title: String?
  private var message: String?
  private var style: UIAlertController.Style = .alert
  private var actions: [UIAlertAction] = []
  private var placeholders: [String] = []
}

// MARK: - Setting Method
extension AlertManager {
  func setTitle(_ text: String) -> AlertManager {
    return AlertManager(title: text,
                        message: message,
                        style: style,
                        actions: actions,
                        placeholders: placeholders)
  }
  
  func setMessage(_ text: String) -> AlertManager {
    return AlertManager(title: title,
                        message: text,
                        style: style,
                        actions: actions,
                        placeholders: placeholders)
  }
  
  func setStyle(_ alertStyle: UIAlertController.Style) -> AlertManager {
    return AlertManager(title: title,
                        message: message,
                        style: alertStyle,
                        actions: actions,
                        placeholders: placeholders)
  }
  
  func setAction(_ alertAction: UIAlertAction) -> AlertManager {
    var newActions = actions
    newActions.append(alertAction)
    return AlertManager(title: title,
                        message: message,
                        style: style,
                        actions: newActions,
                        placeholders: placeholders)
  }
  
  func setActions(_ alertActions: [UIAlertAction]) -> AlertManager {
    return AlertManager(title: title,
                        message: message,
                        style: style,
                        actions: actions + alertActions,
                        placeholders: placeholders)
  }
  
  func setTextField(_ placeholder: String?) -> AlertManager {
    var newPlaceholders = placeholders
    newPlaceholders.append(placeholder ?? "")
    return AlertManager(title: title,
                        message: message,
                        style: style,
                        actions: actions,
                        placeholders: newPlaceholders)
  }
  
  func buildAlert() -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: style
    )
    
    actions.forEach {
      alert.addAction($0)
    }
    
    placeholders.forEach { placeholder in
      alert.addTextField { textField in
        textField.placeholder = placeholder
      }
    }
    
    return alert
  }
}

extension AlertManager {
  static func failAlert(_ message: String) -> AlertManager {
    let okAction = UIAlertAction(title: "Yes", style: .cancel)
    
    return AlertManager(title: "Failure",
                        message: message,
                        actions: [okAction])
  }
}
