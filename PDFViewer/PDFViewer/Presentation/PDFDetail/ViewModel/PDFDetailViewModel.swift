//
//  PDFDetailViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import PDFKit

protocol PDFDetailViewModelInput {
    func addBookmark(at index: Int) throws
    func deleteBookmark(at index: Int) throws
    func bookMarks() -> [Int]?
    
    func storeMemo(text: String, index: Int) throws
    func memo(at index: Int) -> String
}

protocol PDFDetailViewModelOutput {
    var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { get }
}

typealias PDFDetailViewModel = PDFDetailViewModelInput & PDFDetailViewModelOutput

final class DefaultPDFDetailViewModel: PDFDetailViewModel {
    
    // MARK: - Private Property
    private let repository: RealmRepository
    private let index: Int
    private var pdfData: PDFData?
    @Published private var pdfDocument: PDFDocument?
    
    // MARK: - Life Cycle
    init(repository: RealmRepository,
         index: Int
    ) {
        self.repository = repository
        self.index = index
        
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
            Task {
                await loadPDFDocument()
            }
        }
    }

    private func loadPDFDocument() async {
        guard let pdfURL = pdfData?.url else {
            return
        }
        
        pdfDocument = PDFDocument(url: pdfURL)
    }
}

// MARK: - INPUT View event methods
extension DefaultPDFDetailViewModel {
    func addBookmark(at index: Int) throws {
        guard let pdfData else {
            return
        }
        
        var newPDFData = pdfData
        newPDFData.bookMark[index] = true
        
        try repository.updatePDFEntity(pdfData: newPDFData)
        loadPDFData()
    }
    
    func deleteBookmark(at index: Int) throws {
        guard let pdfData else {
            return
        }
        
        var newPDFData = pdfData
        newPDFData.bookMark[index] = false
        
        try repository.updatePDFEntity(pdfData: newPDFData)
        loadPDFData()
    }
    
    func bookMarks() -> [Int]? {
        guard let pdfData else {
            return nil
        }
        
        let bookmarkIndexs = pdfData.bookMark.filter { $0.value == true }
        
        return Array(bookmarkIndexs.keys)
    }
    
    func storeMemo(text: String, index: Int) throws {
        guard let pdfData else {
            return
        }
        
        var newPDFData = pdfData
        newPDFData.memo[index] = text
        
        try repository.updatePDFEntity(pdfData: newPDFData)
        loadPDFData()
    }
    
    func memo(at index: Int) -> String {
        return pdfData?.memo[index] ?? ""
    }
}
