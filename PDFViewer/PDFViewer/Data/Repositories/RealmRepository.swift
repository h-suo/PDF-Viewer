//
//  RealmRepository.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/16.
//

import RealmSwift
import PDFKit

class RealmRepository {
    
    // MARK: - Static Property
    static let shared = RealmRepository()
    
    // MARK: - Private Property
    private var realm: Realm
    
    // MARK: - Life Cycle
    private init() {
        realm = try! Realm()
    }
    
    // MARK: - CRUD Function
    func readAllPDFEntities() -> [PDFData] {
        let objects = realm.objects(PDFDTO.self)
        let pdfDTOs = Array(objects)
        
        return pdfDTOs.compactMap {
            PDFDataTranslater.convertToPDFData(pdfDTO: $0)
        }
    }

    func readPDFEntity(withID id: UUID) -> PDFData? {
        guard let pdfDTO = realm.object(ofType: PDFDTO.self, forPrimaryKey: id) else {
            return nil
        }
        
        return PDFDataTranslater.convertToPDFData(pdfDTO: pdfDTO)
    }
    
    func createPDFEntity(title: String, url: URL) throws {
        guard url.absoluteString.hasSuffix("pdf") else {
            throw UseCaseError.storeDataFailed
        }
        
        let pdfData = PDFData(title: title, url: url)
        let pdfDTO = PDFDataTranslater.convertToPDFDTO(pdfData: pdfData)
        
        do {
            try realm.write {
                realm.add(pdfDTO)
            }
        } catch {
            throw RepositoryError.creationFailed
        }
    }

    func updatePDFEntity(pdfData: PDFData) throws {
        let pdfDTO = PDFDataTranslater.convertToPDFDTO(pdfData: pdfData)
        
        do {
            try realm.write {
                realm.add(pdfDTO, update: .modified)
            }
        } catch {
            throw RepositoryError.updateFailed
        }
    }

    func deletePDFEntity(pdfData: PDFData) throws {
        let pdfDTO = PDFDataTranslater.convertToPDFDTO(pdfData: pdfData)
        
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
