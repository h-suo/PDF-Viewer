//
//  PDFDetailViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import PDFKit

protocol PDFDetailViewModelInput {
  func updateBookmark(at index: Int) throws
  func updateHighlight(textList: [String], index: Int) throws
  func updateMemo(text: String, index: Int) throws
  func updateCurrentPage(at index: Int)
}

protocol PDFDetailViewModelOutput {
  var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { get }
  var bookmarkIndexsPublisher: Published<[Int]>.Publisher { get }
  var isBookmarkPublisher: Published<Bool>.Publisher { get }
  var highlightsPublisher: Published<[String]>.Publisher { get }
  var memoPublisher: Published<String>.Publisher { get }
}

typealias PDFDetailViewModel = PDFDetailViewModelInput & PDFDetailViewModelOutput

final class DefaultPDFDetailViewModel: PDFDetailViewModel {
  
  // MARK: - Private Property
  private let repository: Repository
  private let index: Int
  private var pdfData: PDFData?
  @Published private var pdfDocument: PDFDocument?
  @Published private var bookmarkIndexs: [Int]
  @Published private var isBookmark: Bool
  @Published private var highlights: [String]
  @Published private var memo: String
  
  // MARK: - Life Cycle
  init(
    repository: Repository,
    index: Int
  ) {
    self.repository = repository
    self.index = index
    self.bookmarkIndexs = []
    self.isBookmark = false
    self.highlights = []
    self.memo = String.empty
    
    loadPDFData()
    loadBookmarkIndexs()
  }
  
  // MARK: - OUTPUT
  var pdfDocumentPublisher: Published<PDFDocument?>.Publisher { $pdfDocument }
  var bookmarkIndexsPublisher: Published<[Int]>.Publisher { $bookmarkIndexs }
  var isBookmarkPublisher: Published<Bool>.Publisher { $isBookmark }
  var highlightsPublisher: Published<[String]>.Publisher { $highlights }
  var memoPublisher: Published<String>.Publisher { $memo }
}

// MARK: - Load Data
extension DefaultPDFDetailViewModel {
  private func loadPDFData() {
    let pdfDatas = repository.readPDFDatas()
    let url = pdfDatas[index].url
    pdfData = pdfDatas[index]
    
    if pdfDocument == nil {
      Task {
        await loadPDFDocument(url)
      }
    }
  }
  
  private func loadPDFDocument(_ url: URL) async {
    pdfDocument = PDFDocument(url: url)
  }
  
  private func loadBookmarkIndexs() {
    guard let pdfData else {
      return
    }
    
    bookmarkIndexs = Array(pdfData.bookMark.filter { $0.value == true }.keys)
  }
}

// MARK: - INPUT
extension DefaultPDFDetailViewModel {
  func updateCurrentPage(at index: Int) {
    guard let pdfData else {
      return
    }
    
    isBookmark = pdfData.bookMark[index] ?? false
    highlights = pdfData
      .highlight[index]?
      .split(separator: Character.enter)
      .map { String($0) } ?? []
    memo = pdfData.memo[index] ?? String.empty
  }
  
  func updateBookmark(at index: Int) throws {
    guard let pdfData else {
      return
    }
    
    var newPDFData = pdfData
    let isBookmark = newPDFData.bookMark[index, default: false]
    newPDFData.bookMark[index] = isBookmark ? false : true
    
    try repository.updatePDFData(pdfData: newPDFData)
    loadPDFData()
    loadBookmarkIndexs()
    updateCurrentPage(at: index)
  }
  
  func updateHighlight(textList: [String], index: Int) throws {
    guard let pdfData else {
      return
    }
    
    var newPDFData = pdfData
    var highlights = newPDFData
      .highlight[index]?
      .split(separator: Character.enter)
      .map { String($0) } ?? []
    
    textList.forEach {
      if highlights.contains($0) {
        let index = highlights.firstIndex(of: $0)!
        highlights.remove(at: index)
      } else {
        highlights.append($0)
      }
    }
    
    newPDFData.highlight[index] = highlights.joined(separator: String.enter)
    
    try repository.updatePDFData(pdfData: newPDFData)
    loadPDFData()
    updateCurrentPage(at: index)
  }
  
  func updateMemo(text: String, index: Int) throws {
    guard let pdfData else {
      return
    }
    
    var newPDFData = pdfData
    newPDFData.memo[index] = text
    
    try repository.updatePDFData(pdfData: newPDFData)
    loadPDFData()
    updateCurrentPage(at: index)
  }
}
