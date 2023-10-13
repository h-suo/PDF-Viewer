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
        pdfView.displayMode = .singlePage
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
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    @objc func tapNextButton() {
        viewModel.tapNextButton(pdfView)
    }
    
    @objc func tapBackButton() {
        viewModel.tapBackButton(pdfView)
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
        configureToolBar()
        configureView()
        configureLayout()
    }
    
    private func configureNavigation() {
        navigationItem.title = "PDF Detail"
    }
    
    private func configureToolBar() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(tapNextButton))
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(tapBackButton))
        
        navigationController?.isToolbarHidden = false
        toolbarItems = [backButton, flexibleSpace, nextButton]
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
