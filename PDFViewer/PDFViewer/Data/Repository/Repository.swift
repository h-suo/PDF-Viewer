//
//  Repository.swift
//  PDFViewer
//
//  Created by Erick on 2023/11/21.
//

import Foundation

protocol Repository {
  func readPDFDatas() -> [PDFData]
  func createPDFData(title: String, url: URL) throws
  func updatePDFData(pdfData: PDFData) throws
  func deletePDFData(pdfData: PDFData) throws
}
