//
//  PDFViewerUseCase.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import PDFKit

protocol PDFViewerUseCase {
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { get }
    
    func storePDFData(title: String, url: URL) async throws
    func convertPDFDocument(url: URL) async -> PDFDocument?
    func addBookmarkPDF(to pdfData: PDFData, with index: Int)
    func deleteBookmarkPDF(to pdfData: PDFData, with index: Int)
}

final class DefaultPDFViewerUseCase: PDFViewerUseCase {
    
    // MARK: - Private Property
    @Published private var pdfDatas: [PDFData] = []
    
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { $pdfDatas }
    
    func storePDFData(title: String, url: URL) async throws {
        guard PDFDocument(url: url) != nil else {
            throw PDFDataError.invalidURL
        }
        
        let pdfData = PDFData(title: title, url: url)
        
        pdfDatas.append(pdfData)
    }
    
    func convertPDFDocument(url: URL) async -> PDFDocument? {
        return PDFDocument(url: url)
    }
    
    func addBookmarkPDF(to pdfData: PDFData, with index: Int) {
        if let dataIndex = pdfDatas.firstIndex(of: pdfData) {
            var pdfData = pdfDatas[dataIndex]
            pdfData.bookMark[index] = true
            
            pdfDatas[dataIndex] = pdfData
        }
    }
    
    func deleteBookmarkPDF(to pdfData: PDFData, with index: Int) {
        if let dataIndex = pdfDatas.firstIndex(of: pdfData) {
            var pdfData = pdfDatas[dataIndex]
            pdfData.bookMark[index] = true
            
            pdfDatas[dataIndex] = pdfData
        }
    }
}
