//
//  UIViewController+.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import UIKit

extension UIViewController {
    func presentFailAlert(message: String) {
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .cancel)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}
