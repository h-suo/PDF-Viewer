//
//  PDFDetailViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import PDFKit

protocol PDFDetailViewModelInput {
    func viewDidLoad()
    func tapNextButton(_ pdfView: PDFView)
    func tapBackButton(_ pdfView: PDFView)
}

protocol PDFDetailViewModelOutput {
    var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { get }
}

typealias PDFDetailViewModel = PDFDetailViewModelInput & PDFDetailViewModelOutput

final class DefaultPDFDetailViewModel: PDFDetailViewModel {
    
    // MARK: - Private Property
    private let useCase: PDFViewerUseCase
    private var pdfData: PDFData
    @Published private var pdfDocument: PDFDocument?
    
    // MARK: - Life Cycle
    init(useCase: PDFViewerUseCase, pdfData: PDFData) {
        self.useCase = useCase
        self.pdfData = pdfData
        
        loadPDFDocument()
    }
    
    // MARK: - OUTPUT
    var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { $pdfDocument }
}

// MARK: - Load Data
extension DefaultPDFDetailViewModel {
    private func loadPDFDocument() {
        let pdfURL = pdfData.url
        
        Task {
            pdfDocument = await useCase.convertPDFDocument(url: pdfURL)
        }
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
}
