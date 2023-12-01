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
  
  private let viewModel: PDFDetailViewModel
  private var cancellables: [AnyCancellable]
  private var bookmarkIndexs: [Int]
  private var memo: String
  
  // MARK: - Life Cycle
  init(viewModel: PDFDetailViewModel) {
    self.viewModel = viewModel
    self.cancellables = []
    self.bookmarkIndexs = []
    self.memo = String.empty
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindingPDFDocument()
    bindingBookmarkIndexs()
    bindingIsBookmark()
    bindingHighlights()
    bindingMemo()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isToolbarHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.isToolbarHidden = true
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
  private func bindingPDFDocument() {
    viewModel.pdfDocumentPublisher.sink { pdfDocument in
      self.configurePDFView(pdfDocument: pdfDocument)
    }.store(in: &cancellables)
  }
  
  private func bindingBookmarkIndexs() {
    viewModel.bookmarkIndexsPublisher.sink { bookmarkIndexs in
      self.bookmarkIndexs = bookmarkIndexs
    }.store(in: &cancellables)
  }
  
  private func bindingIsBookmark() {
    viewModel.isBookmarkPublisher.sink { isBookmark in
      self.configureNavigation(isBookmark)
    }.store(in: &cancellables)
  }
  
  private func bindingHighlights() {
    viewModel.highlightsPublisher.sink { highlights in
      self.configureHighlight(highlights)
    }.store(in: &cancellables)
  }
  
  private func bindingMemo() {
    viewModel.memoPublisher.sink { memo in
      self.memo = memo
    }.store(in: &cancellables)
  }
}

// MARK: - View Event
extension PDFDetailViewController {
  
  // MARK: - Update CurrentPage
  @objc private func updateCurrentPage() {
    guard let currentIndex = currentIndex() else {
      return
    }
    
    viewModel.updateCurrentPage(at: currentIndex)
  }
  
  // MARK: - Move PDF Page
  @objc private func tapNextButton() {
    pdfView.goToNextPage(nil)
    updateCurrentPage()
    configurePageLabel()
  }
  
  @objc private func tapBackButton() {
    pdfView.goToPreviousPage(nil)
    updateCurrentPage()
    configurePageLabel()
  }
  
  // MARK: - Bookmark
  private func updateBookmark(_ action: UIAction) {
    guard let currentIndex = currentIndex() else {
      return
    }
    
    do {
      try viewModel.updateBookmark(at: currentIndex)
    } catch {
      presentFailAlert(message: error.localizedDescription)
    }
  }
  
  private func moveBookmark(_ action: UIAction) {
    let cancelAction = UIAlertAction(title: NameSpace.cancel, style: .cancel)
    let alert = AlertManager()
      .setTitle(NameSpace.bookmark)
      .setStyle(.actionSheet)
      .setAction(cancelAction)
      .buildAlert()
    
    bookmarkIndexs.forEach { index in
      let action = UIAlertAction(
        title: String(format: NameSpace.pageTitleFormat, index + 1),
        style: .default,
        handler: { _ in
          guard let page = self.pdfView.document?.page(at: index) else {
            return
          }
          
          self.pdfView.go(to: page)
          self.updateCurrentPage()
          self.configurePageLabel()
        }
      )
      
      alert.addAction(action)
    }
    
    present(alert, animated: true)
  }
  
  // MARK: - Highlight
  private func updateHighlight(_ action: UIAction) {
    guard let currentIndex = currentIndex(),
          let currentSelection = pdfView.currentSelection else {
      return
    }
    
    let selections = currentSelection.selectionsByLine()
    let highlights = selections.compactMap { $0.string }
    
    do {
      try viewModel.updateHighlight(textList: highlights, index: currentIndex)
    } catch {
      presentFailAlert(message: error.localizedDescription)
    }
    
    pdfView.clearSelection()
  }
  
  // MARK: - Memo
  private func showMemoView(_ action: UIAction) {
    guard let currentIndex = currentIndex() else {
      return
    }
    
    let memo = memo
    let memoViewController = DIContainer().makePDFMemoViewController(
      text: memo,
      index: currentIndex
    )
    memoViewController.delegate = self
    
    navigationController?.pushViewController(memoViewController, animated: true)
  }
}

// MARK: - Configure UI Object
extension PDFDetailViewController {
  private func configurePDFView(pdfDocument: PDFDocument?) {
    DispatchQueue.main.async {
      self.pdfView.document = pdfDocument
      self.updateCurrentPage()
      self.configurePageLabel()
    }
  }
  
  private func configurePageLabel() {
    if let currentPage: PDFPage = pdfView.currentPage,
       let pageIndex: Int = pdfView.document?.index(for: currentPage) {
      
      let pageNumberText = String(
        format: NameSpace.pageNumberFormat,
        pageIndex + 1,
        pdfView.document?.pageCount ?? .zero
      )
      pageNumberView.configurePageNumber(pageNumberText)
    }
  }
  
  private func configureHighlight(_ highlights: [String]) {
    pdfView.currentPage?.annotations.forEach {
      pdfView.currentPage?.removeAnnotation($0)
    }
    
    let selections = highlights.compactMap {
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
}

// MARK: - PDFMemoViewController Delegate
extension PDFDetailViewController: PDFMemoViewControllerDelegate {
  func pdfMemoViewController(
    _ pdfMemoViewController: PDFMemoViewController,
    takeNotes text: String,
    noteIndex: Int
  ) {
    do {
      try viewModel.updateMemo(text: text, index: noteIndex)
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
        title: NameSpace.bookmark,
        image: UIImage(systemName: isBookmark ? NameSpace.bookmarkFill : NameSpace.bookmark),
        handler: updateBookmark
      ),
      UIAction(
        title: NameSpace.moveBookmark,
        image: UIImage(systemName: NameSpace.book),
        handler: moveBookmark
      ),
      UIAction(
        title: NameSpace.highlight,
        image: UIImage(systemName: NameSpace.highlighter),
        handler: updateHighlight
      ),
      UIAction(
        title: NameSpace.memo,
        image: UIImage(systemName: NameSpace.note),
        handler: showMemoView
      )
    ]
  }
  
  private func configureNavigation(_ isBookmark: Bool) {
    let moreButton = UIBarButtonItem(
      image: UIImage(systemName: NameSpace.ellipsis),
      style: .plain,
      target: self,
      action: nil
    )
    moreButton.menu = UIMenu(children: configureActions(isBookmark))
    
    navigationItem.rightBarButtonItem = moreButton
    navigationItem.title = NameSpace.pdfDetail
  }
  
  private func configureToolBar() {
    toolbarItems = [
      UIBarButtonItem(
        image: UIImage(systemName: NameSpace.chevronLeft),
        style: .plain, target: self,
        action: #selector(tapBackButton)
      ),
      UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: nil,
        action: nil
      ),
      UIBarButtonItem(
        image: UIImage(systemName: NameSpace.chevronRight),
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
