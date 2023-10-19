//
//  PDFListViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import Foundation

protocol PDFListViewModelInput {
    func storePDF(title: String, urlString: String) throws
    func deletePDF(at index: Int) throws
}

protocol PDFListViewModelOutput {
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { get }
}

typealias PDFListViewModel = PDFListViewModelInput & PDFListViewModelOutput

final class DefaultPDFListViewModel: PDFListViewModel {
    
    // MARK: - Private Property
    private let repository: RealmRepository
    @Published private var pdfDatas: [PDFData] = []
    
    // MARK: - Life Cycle
    init(repository: RealmRepository) {
        self.repository = repository
        
        loadPDFData()
    }
    
    // MARK: - OUTPUT
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { $pdfDatas }
}

// MARK: - Load Data
extension DefaultPDFListViewModel {
    private func loadPDFData() {
        pdfDatas = repository.readAllPDFEntities()
    }
}

// MARK: - INPUT View event methods
extension DefaultPDFListViewModel {    
    func storePDF(title: String, urlString: String) throws {
        if title == "" || urlString == "" {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        try repository.createPDFEntity(title: title, url: url)
        loadPDFData()
    }
    
    func deletePDF(at index: Int) throws {
        let deletePDFData = pdfDatas[index]
        
        try repository.deletePDFEntity(pdfData: deletePDFData)
        loadPDFData()
    }
}
