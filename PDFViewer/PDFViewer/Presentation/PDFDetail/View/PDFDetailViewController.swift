//
//  PDFDetailViewController.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import UIKit
import PDFKit

final class PDFDetailViewController: UIViewController {
    
    // MARK: - Private Property
    private var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        return pdfView
    }()
    
    // MARK: - View Event
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - Configure UI Object
extension PDFDetailViewController {
    private func configurePDFView(pdfDocument: PDFDocument) {
        pdfView.document = pdfDocument
    }
}

// MARK: - Configure UI
extension PDFDetailViewController {
    private func configureUI() {
        configureNavigation()
        configureView()
        configureLayout()
    }
    
    private func configureNavigation() {
        navigationItem.title = "PDF Detail"
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(pdfView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
