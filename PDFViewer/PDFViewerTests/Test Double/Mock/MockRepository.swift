//
//  MockRepository.swift
//  PDFViewerTests
//
//  Created by Erick on 2023/12/03.
//

import Foundation
@testable import PDFViewer

final class MockRepository: Repository {
  
  private var pdfDatas: [PDFData]
  
  init(pdfDatas: [PDFData]) {
    self.pdfDatas = pdfDatas
  }
  
  func readPDFDatas() -> [PDFData] {
    return pdfDatas
  }
  
  func createPDFData(title: String, url: URL) throws {
    guard url.absoluteString.hasSuffix("pdf") else {
      throw RepositoryError.invalidURL
    }
    
    let pdfData = PDFData(title: title, url: url)
    pdfDatas.append(pdfData)
  }
  
  func updatePDFData(pdfData: PDFData) throws {
    var targetIndex = -1
    
    for (index, value) in pdfDatas.enumerated() where value.id == pdfData.id {
      targetIndex = index
    }
    
    guard (0..<pdfDatas.count).contains(targetIndex) else {
      throw RepositoryError.updateFailed
    }
    
    pdfDatas[targetIndex] = pdfData
  }
  
  func deletePDFData(pdfData: PDFData) throws {
    var targetIndex = -1
    
    for (index, value) in pdfDatas.enumerated() where value.id == pdfData.id {
      targetIndex = index
    }
    
    guard (0..<pdfDatas.count).contains(targetIndex) else {
      throw RepositoryError.deletionFailed
    }
    
    pdfDatas.remove(at: targetIndex)
  }
}
