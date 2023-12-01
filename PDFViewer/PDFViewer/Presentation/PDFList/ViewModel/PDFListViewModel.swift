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
  func searchPDF(_ text: String)
}

protocol PDFListViewModelOutput {
  var pdfDatasPublisher: Published<[PDFData]>.Publisher { get }
  var searchPDFDatasPublisher: Published<[PDFData]>.Publisher { get }
}

typealias PDFListViewModel = PDFListViewModelInput & PDFListViewModelOutput

final class DefaultPDFListViewModel: PDFListViewModel {
  
  // MARK: - Private Property
  private let repository: Repository
  @Published private var pdfDatas: [PDFData] = []
  @Published private var searchPDFDatas: [PDFData] = []
  
  // MARK: - Life Cycle
  init(repository: Repository) {
    self.repository = repository
    
    loadPDFData()
  }
  
  // MARK: - OUTPUT
  var pdfDatasPublisher: Published<[PDFData]>.Publisher { $pdfDatas }
  var searchPDFDatasPublisher: Published<[PDFData]>.Publisher { $searchPDFDatas }
}

// MARK: - Load Data
extension DefaultPDFListViewModel {
  private func loadPDFData() {
    pdfDatas = repository.readAllPDFDatas()
  }
}

// MARK: - INPUT
extension DefaultPDFListViewModel {
  func storePDF(title: String, urlString: String) throws {
    if title == String.empty || urlString == String.empty {
      return
    }
    
    guard let url = URL(string: urlString) else {
      return
    }
    
    try repository.createPDFData(title: title, url: url)
    loadPDFData()
  }
  
  func deletePDF(at index: Int) throws {
    let deletePDFData = pdfDatas[index]
    
    try repository.deletePDFData(pdfData: deletePDFData)
    loadPDFData()
  }
  
  func searchPDF(_ text: String) {
    searchPDFDatas = pdfDatas.filter { $0.title.lowercased().hasPrefix(text) }
  }
}
