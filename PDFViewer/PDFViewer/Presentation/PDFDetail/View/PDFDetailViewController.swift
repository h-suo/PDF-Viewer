//
//  PDFDetailViewController.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import Combine
import PDFKit
import UIKit

final class PDFDetailViewController: UIViewController {
  
  // MARK: - Private Property
  private let pdfView: PDFView = {
    let pdfView = PDFView()
    pdfView.translatesAutoresizingMaskIntoConstraints = false
    pdfView.autoScales = true
    pdfView.displayMode = .singlePage
    pdfView.displayDirection = .vertical
    
    return pdfView
  }()
  
  private let pageNumberView: PageNumberView = {
    let pageNumberView = PageNumberView()
    pageNumberView.translatesAutoresizingMaskIntoConstraints = false
    
    return pageNumberView
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isToolbarHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isToolbarHidden = true
  }
  
  @objc private func tapNextButton() {
    pdfView.goToNextPage(nil)
    configurePageLabel()
    checkBookmark()
    configureHighlight()
  }
  
  @objc private func tapBackButton() {
    pdfView.goToPreviousPage(nil)
    configurePageLabel()
    checkBookmark()
    configureHighlight()
  }
  
  private func updateBookmark(_ action: UIAction) {
    guard let currentIndex = currentIndex() else {
      return
    }
    
    do {
      try viewModel.updateBookmark(at: currentIndex)
      checkBookmark()
    } catch {
      presentFailAlert(message: error.localizedDescription)
    }
  }
  
  private func moveBookmark(_ action: UIAction) {
    guard let bookmarkIndexs = viewModel.bookmarks() else {
      return
    }
    
    let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
    let alert = AlertManager()
      .setTitle("bookmark")
      .setStyle(.actionSheet)
      .setAction(cancelAction)
      .buildAlert()
    
    bookmarkIndexs.forEach { index in
      let action = UIAlertAction(title: "page \(index + 1)", style: .default) { _ in
        guard let page = self.pdfView.document?.page(at: index) else {
          return
        }
        
        self.pdfView.go(to: page)
        self.configurePageLabel()
        self.checkBookmark()
        self.configureHighlight()
      }
      
      alert.addAction(action)
    }
    
    present(alert, animated: true)
  }
  
  private func checkBookmark() {
    guard let currentIndex = currentIndex() else {
      return
    }
    
    let isBookmark = viewModel.checkBookmark(at: currentIndex)
    configureNavigation(isBookmark)
    configureHighlight()
  }
  
  private func updateHighlight(_ action: UIAction) {
    guard let currentIndex = currentIndex(),
          let currentSelection = pdfView.currentSelection else {
      return
    }
    
    let selections = currentSelection.selectionsByLine()
    let highlights = selections.compactMap { $0.string }
    
    do {
      try viewModel.updateHighlight(textList: highlights, index: currentIndex)
      configureHighlight()
    } catch {
      presentFailAlert(message: error.localizedDescription)
    }
    
    pdfView.clearSelection()
  }
  
  private func configureHighlight() {
    guard let currentIndex = currentIndex() else {
      return
    }
    
    let selections = viewModel.highlight(at: currentIndex).compactMap {
      pdfView.document?.findString($0, withOptions: .caseInsensitive).first
    }
    
    guard let page = selections.first?.pages.first else {
      return
    }
    
    selections.forEach { selection in
      let highlight = PDFAnnotation(
        bounds: selection.bounds(for: page),
        forType: .highlight,
        withProperties: nil
      )
      highlight.endLineStyle = .square
      
      page.addAnnotation(highlight)
    }
  }
  
  private func showMemoView(_ action: UIAction) {
    guard let currentIndex = currentIndex() else {
      return
    }
    
    let memo = viewModel.memo(at: currentIndex)
    let memoViewController = DIContainer().makePDFMemoViewController(
      text: memo,
      index: currentIndex
    )
    memoViewController.delegate = self
    
    navigationController?.pushViewController(memoViewController, animated: true)
  }
  
  private func currentIndex() -> Int? {
    guard let currentPage = pdfView.currentPage,
          let currentIndex = pdfView.document?.index(for: currentPage) else {
      return nil
    }
    
    return currentIndex
  }
}

// MARK: - Data Binding
extension PDFDetailViewController {
  private func setupBindings() {
    viewModel.pdfDocumentPublisher.sink { pdfDocument in
      self.configurePDFView(pdfDocument: pdfDocument)
    }.store(in: &cancellables)
  }
}

// MARK: - Configure UI Object
extension PDFDetailViewController {
  private func configurePDFView(pdfDocument: PDFDocument?) {
    DispatchQueue.main.async {
      self.pdfView.document = pdfDocument
      self.configurePageLabel()
      self.checkBookmark()
      self.configureHighlight()
    }
  }
  
  private func configurePageLabel() {
    if let currentPage: PDFPage = pdfView.currentPage,
       let pageIndex: Int = pdfView.document?.index(for: currentPage) {
      
      let pageNumberText = "\(pageIndex + 1) / \(pdfView.document?.pageCount ?? .zero)"
      pageNumberView.configurePageNumber(pageNumberText)
    }
  }
}

// MARK: - PDFMemoViewController Delegate
extension PDFDetailViewController: PDFMemoViewControllerDelegate {
  func pdfMemoViewController(
    _ pdfMemoViewController: PDFMemoViewController,
    takeNotes text: String,
    noteIndex: Int
  ) {
    do {
      try viewModel.storeMemo(text: text, index: noteIndex)
    } catch {
      presentFailAlert(message: error.localizedDescription)
    }
  }
}

// MARK: - Configure UI
extension PDFDetailViewController {
  private func configureUI() {
    configureNavigation(false)
    configureToolBar()
    configureView()
    configureLayout()
  }
  
  private func configureActions(_ isBookmark: Bool) -> [UIAction] {
    return [
      UIAction(
        title: "bookmark",
        image: UIImage(systemName: isBookmark ? "bookmark.fill" : "bookmark"),
        handler: updateBookmark
      ),
      UIAction(
        title: "move bookmark",
        image: UIImage(systemName: "book"),
        handler: moveBookmark
      ),
      UIAction(
        title: "highlight",
        image: UIImage(systemName: "highlighter"),
        handler: updateHighlight
      ),
      UIAction(
        title: "memo",
        image: UIImage(systemName: "note"),
        handler: showMemoView
      )
    ]
  }
  
  private func configureNavigation(_ isBookmark: Bool) {
    let moreButton = UIBarButtonItem(
      image: UIImage(systemName: "ellipsis"),
      style: .plain,
      target: self,
      action: nil
    )
    moreButton.menu = UIMenu(children: configureActions(isBookmark))
    
    navigationItem.rightBarButtonItem = moreButton
    navigationItem.title = "PDF Detail"
  }
  
  private func configureToolBar() {
    toolbarItems = [
      UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain, target: self,
        action: #selector(tapBackButton)
      ),
      UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: nil,
        action: nil
      ),
      UIBarButtonItem(
        image: UIImage(systemName: "chevron.right"),
        style: .plain,
        target: self,
        action: #selector(tapNextButton)
      )
    ]
  }
  
  private func configureView() {
    view.backgroundColor = .systemBackground
    view.addSubview(pdfView)
    pdfView.addSubview(pageNumberView)
  }
  
  private func configureLayout() {
    let safeArea = view.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      pdfView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      pdfView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      pdfView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      pdfView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
    
    NSLayoutConstraint.activate([
      pageNumberView.centerXAnchor.constraint(equalTo: pdfView.centerXAnchor),
      pageNumberView.widthAnchor.constraint(
        greaterThanOrEqualTo: pdfView.widthAnchor,
        multiplier: 0.1
      ),
      pageNumberView.heightAnchor.constraint(
        equalTo: pageNumberView.widthAnchor,
        multiplier: 0.5
      ),
      pageNumberView.bottomAnchor.constraint(equalTo: pdfView.bottomAnchor, constant: -8)
    ])
  }
}
