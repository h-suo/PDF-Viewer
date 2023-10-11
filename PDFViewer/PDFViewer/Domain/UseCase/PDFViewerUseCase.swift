//
//  PDFViewerUseCase.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import PDFKit

protocol PDFViewerUseCase {
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { get }
    
    func storePDFData(title: String, url: URL)
}

final class DefaultPDFViewerUseCase: PDFViewerUseCase {
    
    // MARK: - Private Property
    @Published private var pdfDatas: [PDFData] = []
    
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { $pdfDatas }
    
    func storePDFData(title: String, url: URL) {
        let pdfData = PDFData(title: title, url: url)
        pdfDatas.append(pdfData)
    }
}
