//
//  UIViewController+.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import UIKit

extension UIViewController {
    func presentFailAlert(message: String) {
        let alert = AlertManager
            .failAlert(message)
            .buildAlert()
        
        self.present(alert, animated: true)
    }
}
