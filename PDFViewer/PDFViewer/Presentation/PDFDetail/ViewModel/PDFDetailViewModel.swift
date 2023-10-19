//
//  PDFDetailViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import PDFKit

struct PDFDetailViewModelAction {
    let showBookmarkAlert: (UIAlertController) -> Void
    let showFailAlert: (String) -> Void
    let showMemoView: (UIViewController) -> Void
}

protocol PDFDetailViewModelInput {
    func viewDidLoad()
    func tapNextButton(_ pdfView: PDFView)
    func tapBackButton(_ pdfView: PDFView)
    func addBookmark(_ pdfView: PDFView)
    func deleteBookmark(_ pdfView: PDFView)
    func moveBookmark(_ pdfView: PDFView)
    func showMemoView(_ pdfView: PDFView)
}

protocol PDFDetailViewModelOutput {
    var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { get }
}

typealias PDFDetailViewModel = PDFDetailViewModelInput & PDFDetailViewModelOutput

final class DefaultPDFDetailViewModel: PDFDetailViewModel {
    
    // MARK: - Private Property
    private let repository: RealmRepository
    private let actions: PDFDetailViewModelAction
    private let index: Int
    private var pdfData: PDFData?
    @Published private var pdfDocument: PDFDocument?
    
    // MARK: - Life Cycle
    init(repository: RealmRepository,
         index: Int,
         actions: PDFDetailViewModelAction
    ) {
        self.repository = repository
        self.index = index
        self.actions = actions
        
        loadPDFData()
    }
    
    // MARK: - OUTPUT
    var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { $pdfDocument }
}

// MARK: - Load Data
extension DefaultPDFDetailViewModel {
    private func loadPDFData() {
        let pdfDatas = repository.readAllPDFEntities()
        pdfData = pdfDatas[index]
        
        if pdfDocument == nil {
            loadPDFDocument()
        }
    }
}

// MARK: - Load Data
extension DefaultPDFDetailViewModel {
    private func loadPDFDocument() {
        guard let pdfURL = pdfData?.url else {
            return
        }
        
        pdfDocument = PDFDocument(url: pdfURL)
    }
}

// MARK: - INPUT View event methods
extension DefaultPDFDetailViewModel {
    func viewDidLoad() {
    }
    
    func tapNextButton(_ pdfView: PDFView) {
        pdfView.goToNextPage(nil)
    }
    
    func tapBackButton(_ pdfView: PDFView) {
        pdfView.goToPreviousPage(nil)
    }
    
    func addBookmark(_ pdfView: PDFView) {
        guard let currentPage = pdfView.currentPage,
              let currentIndex = pdfView.document?.index(for: currentPage),
              let pdfData else {
            return
        }
        
        var newPDFData = pdfData
        newPDFData.bookMark[currentIndex] = true
        
        do {
            try repository.updatePDFEntity(pdfData: newPDFData)
            loadPDFData()
        } catch {
            actions.showFailAlert(error.localizedDescription)
        }
    }
    
    func deleteBookmark(_ pdfView: PDFView) {
        guard let currentPage = pdfView.currentPage,
              let currentIndex = pdfView.document?.index(for: currentPage),
              let pdfData else {
            return
        }
        
        var newPDFData = pdfData
        newPDFData.bookMark[currentIndex] = false
        
        do {
            try repository.updatePDFEntity(pdfData: newPDFData)
            loadPDFData()
        } catch {
            actions.showFailAlert(error.localizedDescription)
        }
    }
    
    func moveBookmark(_ pdfView: PDFView) {
        let alert = UIAlertController(title: "bookmark", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        let bookmarkIndexs = pdfData?.bookMark.filter { $0.value == true }
        bookmarkIndexs?.keys.forEach { index in
            let action = UIAlertAction(title: "page \(index + 1)", style: .default) { _ in
                guard let page = pdfView.document?.page(at: index) else {
                    return
                }
                
                pdfView.go(to: page)
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(cancelAction)
        
        actions.showBookmarkAlert(alert)
    }
    
    func showMemoView(_ pdfView: PDFView) {
        guard let currentPage = pdfView.currentPage,
              let currentIndex = pdfView.document?.index(for: currentPage) else {
            return
        }
        
        let memo = pdfData?.memo[currentIndex] ?? ""
        let memoViewController = PDFMemoViewController(memo: memo, index: currentIndex)
        memoViewController.delegate = self
        
        actions.showMemoView(memoViewController)
    }
}

extension DefaultPDFDetailViewModel: PDFMemoViewControllerDelegate {
    func pdfMemoViewController(_ pdfMemoViewController: PDFMemoViewController, takeNotes text: String, noteIndex: Int) {
        guard let pdfData else {
            return
        }
        
        var newPDFData = pdfData
        newPDFData.memo[noteIndex] = text
        
        do {
            try repository.updatePDFEntity(pdfData: newPDFData)
            loadPDFData()
        } catch {
            actions.showFailAlert(error.localizedDescription)
        }
    }
}
