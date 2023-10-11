//
//  PDFDetailViewController.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import UIKit
import PDFKit
import Combine

final class PDFDetailViewController: UIViewController {
    
    // MARK: - Private Property
    private var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        return pdfView
    }()
    
    private var cancellables: [AnyCancellable] = []
    private let viewModel: PDFDetailViewModel
    
    // MARK: - Life Cycle
    init(viewModel: PDFDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Event
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
    }
}

// MARK: - Data Binding
extension PDFDetailViewController {
    private func setupBindings() {
        viewModel.pdfDocumentPublisher.sink { [weak self] pdfDocument in
            guard let self else {
                return
            }
            
            self.configurePDFView(pdfDocument: pdfDocument)
        }.store(in: &cancellables)
    }
}

// MARK: - Configure UI Object
extension PDFDetailViewController {
    private func configurePDFView(pdfDocument: PDFDocument?) {
        DispatchQueue.main.async {
            self.pdfView.document = pdfDocument
        }
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
