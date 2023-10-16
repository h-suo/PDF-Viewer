//
//  PDFViewerUseCase.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import PDFKit

protocol PDFViewerUseCase {
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { get }
    
    func convertPDFDocument(url: URL) async -> PDFDocument?
    func storePDFData(title: String, url: URL) throws
    func addBookmarkPDF(to pdfData: PDFData, with index: Int) throws
    func deleteBookmarkPDF(to pdfData: PDFData, with index: Int) throws
    func storePDFMemo(pdfData: PDFData, text: String, index: Int) throws
}

final class DefaultPDFViewerUseCase: PDFViewerUseCase {
    
    // MARK: - Private Property
    private let realmRepository: RealmRepository
    @Published private var pdfDatas: [PDFData]
    
    // MARK: - Life Cycle
    init(realmRepository: RealmRepository, pdfDatas: [PDFData] = []) {
        self.realmRepository = realmRepository
        self.pdfDatas = pdfDatas
        
        loadData()
    }
    
    // MARK: - Load Data
    private func loadData() {
        let pdfEntitys = realmRepository.readAllPDFEntities()
        
        pdfDatas = pdfEntitys.compactMap {
            PDFDataTranslater.convertToPDFData(pdfDTO: $0)
        }
    }
}

extension DefaultPDFViewerUseCase {
    
    // MARK: - PDFViewerUseCase
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { $pdfDatas }
    
    func convertPDFDocument(url: URL) async -> PDFDocument? {
        return PDFDocument(url: url)
    }
    
    func storePDFData(title: String, url: URL) throws {
        guard PDFDocument(url: url) != nil else {
            throw UseCaseError.storeDataFailed
        }
        
        let pdfData = PDFData(title: title, url: url)
        let pdfDTO = PDFDataTranslater.convertToPDFDTO(pdfData: pdfData)
        
        try realmRepository.createPDFEntity(pdfEntity: pdfDTO)
        loadData()
    }
    
    func addBookmarkPDF(to pdfData: PDFData, with index: Int) throws {
        guard let dataIndex = pdfDatas.firstIndex(of: pdfData) else {
            throw UseCaseError.addBookmarkFailed
        }
        
        var pdfData = pdfDatas[dataIndex]
        pdfData.bookMark[index] = true
        
        let pdfDTO = PDFDataTranslater.convertToPDFDTO(pdfData: pdfData)
        
        try realmRepository.updatePDFEntity(pdfEntity: pdfDTO)
        loadData()
    }
    
    func deleteBookmarkPDF(to pdfData: PDFData, with index: Int) throws {
        guard let dataIndex = pdfDatas.firstIndex(of: pdfData) else {
            throw UseCaseError.deleteBookmarkFailed
        }
        
        var pdfData = pdfDatas[dataIndex]
        pdfData.bookMark[index] = false
        
        let pdfDTO = PDFDataTranslater.convertToPDFDTO(pdfData: pdfData)
        
        try realmRepository.updatePDFEntity(pdfEntity: pdfDTO)
        loadData()
    }
    
    func storePDFMemo(pdfData: PDFData, text: String, index: Int) throws {
        guard let dataIndex = pdfDatas.firstIndex(of: pdfData) else {
            throw UseCaseError.storeMemoFailed
        }
        
        var pdfData = pdfDatas[dataIndex]
        pdfData.memo[index] = text
        
        let pdfDTO = PDFDataTranslater.convertToPDFDTO(pdfData: pdfData)
        
        try realmRepository.updatePDFEntity(pdfEntity: pdfDTO)
        loadData()
    }
}
