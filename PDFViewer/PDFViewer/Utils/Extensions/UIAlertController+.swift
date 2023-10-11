//
//  UIAlertController+.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import UIKit

extension UIAlertController {
    static func makeFailAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .cancel)
        alert.addAction(okAction)
        
        return alert
    }
}
