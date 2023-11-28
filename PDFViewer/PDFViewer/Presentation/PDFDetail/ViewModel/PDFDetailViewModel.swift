//
//  PDFDetailViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import PDFKit

protocol PDFDetailViewModelInput {
  func updateBookmark(at index: Int) throws
  func checkBookmark(at index: Int) -> Bool
  func bookmarks() -> [Int]?
  
  func updateHighlight(textList: [String], index: Int) throws
  func highlight(at index: Int) -> [String]
  
  func storeMemo(text: String, index: Int) throws
  func memo(at index: Int) -> String
}

protocol PDFDetailViewModelOutput {
  var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { get }
}

typealias PDFDetailViewModel = PDFDetailViewModelInput & PDFDetailViewModelOutput

final class DefaultPDFDetailViewModel: PDFDetailViewModel {
  
  // MARK: - Private Property
  private let repository: Repository
  private let index: Int
  private var pdfData: PDFData?
  @Published private var pdfDocument: PDFDocument?
  
  // MARK: - Life Cycle
  init(
    repository: Repository,
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
    let pdfDatas = repository.readAllPDFDatas()
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
  func updateBookmark(at index: Int) throws {
    guard let pdfData else {
      return
    }
    
    var newPDFData = pdfData
    let isBookMark = newPDFData.bookMark[index, default: false]
    newPDFData.bookMark[index] = isBookMark ? false : true
    
    try repository.updatePDFData(pdfData: newPDFData)
    loadPDFData()
  }
  
  func checkBookmark(at index: Int) -> Bool {
    return pdfData?.bookMark[index] ?? false
  }
  
  func bookmarks() -> [Int]? {
    guard let pdfData else {
      return nil
    }
    
    let bookmarkIndexs = pdfData.bookMark.filter { $0.value == true }
    
    return Array(bookmarkIndexs.keys)
  }
  
  func updateHighlight(textList: [String], index: Int) throws {
    guard let pdfData else {
      return
    }
    
    var newPDFData = pdfData
    newPDFData.highlight[index] = textList.joined(separator: "\n")
    
    try repository.updatePDFData(pdfData: newPDFData)
    loadPDFData()
  }
  
  func highlight(at index: Int) -> [String] {
    return pdfData?
      .highlight[index]?
      .split(separator: "\n")
      .map { String($0) } ?? []
  }
  
  func storeMemo(text: String, index: Int) throws {
    guard let pdfData else {
      return
    }
    
    var newPDFData = pdfData
    newPDFData.memo[index] = text
    
    try repository.updatePDFData(pdfData: newPDFData)
    loadPDFData()
  }
  
  func memo(at index: Int) -> String {
    return pdfData?.memo[index] ?? ""
  }
}
