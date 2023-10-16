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
    
    @objc private func tapNextButton() {
        viewModel.tapNextButton(pdfView)
    }
    
    @objc private func tapBackButton() {
        viewModel.tapBackButton(pdfView)
    }
    
    private func addBookmark(_ action: UIAction) {
        viewModel.addBookmark(pdfView)
    }
    
    private func deleteBookmark(_ action: UIAction) {
        viewModel.deleteBookmark(pdfView)
    }
    
    private func moveBookmark(_ action: UIAction) {
        viewModel.moveBookmark(pdfView)
    }
    
    private func showMemoView(_ action: UIAction) {
        viewModel.showMemoView(pdfView)
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
        let addBookmarkAction = UIAction(title: "add bookmark", image: UIImage(systemName: "bookmark"), handler: addBookmark)
        let deleteBookmarkAction = UIAction(title: "delete bookmark", image: UIImage(systemName: "bookmark.slash"), handler: deleteBookmark)
        let moveBookmarkAction = UIAction(title: "move bookmark", image: UIImage(systemName: "book"), handler: moveBookmark)
        let memoAction = UIAction(title: "memo", image: UIImage(systemName: "note"), handler: showMemoView)
        let bookmarkMenu = UIMenu(title: "bookmark", children: [addBookmarkAction, deleteBookmarkAction, moveBookmarkAction])
        
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        moreButton.menu = UIMenu(children: [bookmarkMenu, memoAction])
        
        navigationItem.title = "PDF Detail"
        navigationItem.rightBarButtonItem = moreButton
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
