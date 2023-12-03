//
//  RealmRepository.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/16.
//

import Foundation
import RealmSwift

final class RealmRepository: Repository {
  
  // MARK: - Static Property
  static let shared = RealmRepository()
  
  // MARK: - Private Property
  private var realm: Realm
  
  // MARK: - Life Cycle
  private init() {
    realm = try! Realm()
  }
  
  // MARK: - CRUD Function
  func readPDFDatas() -> [PDFData] {
    let objects = realm.objects(PDFDTO.self)
    let pdfDTOs = Array(objects)
    
    return pdfDTOs.compactMap {
      RealmTranslater.convertToPDFData($0)
    }
  }
  
  func createPDFData(title: String, url: URL) throws {
    guard url.absoluteString.hasSuffix("pdf") else {
      throw RepositoryError.invalidURL
    }
    
    let pdfData = PDFData(title: title, url: url)
    let pdfDTO = RealmTranslater.convertToPDFDTO(pdfData: pdfData)
    
    do {
      try realm.write {
        realm.add(pdfDTO)
      }
    } catch {
      throw RepositoryError.creationFailed
    }
  }
  
  func updatePDFData(pdfData: PDFData) throws {
    let pdfDTO = RealmTranslater.convertToPDFDTO(pdfData: pdfData)
    
    do {
      try realm.write {
        realm.add(pdfDTO, update: .modified)
      }
    } catch {
      throw RepositoryError.updateFailed
    }
  }
  
  func deletePDFData(pdfData: PDFData) throws {
    let pdfDTO = RealmTranslater.convertToPDFDTO(pdfData: pdfData)
    
    do {
      try realm.write {
        realm.add(pdfDTO, update: .all)
        realm.delete(pdfDTO)
      }
    } catch {
      throw RepositoryError.deletionFailed
    }
  }
}
