//
//  RealmRepository.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/16.
//

import RealmSwift
import Foundation

class RealmRepository {
    
    // MARK: - Private Property
    private var realm: Realm
    
    // MARK: - Life Cycle
    init?() {
        do {
            self.realm = try Realm()
        } catch {
            return nil
        }
    }
    
    // MARK: - CRUD Function
    func readAllPDFEntities() -> [PDFDTO] {
        let result = realm.objects(PDFDTO.self)
        
        return Array(result)
    }

    func readPDFEntity(withID id: UUID) -> PDFDTO? {
        return realm.object(ofType: PDFDTO.self, forPrimaryKey: id)
    }
    
    func createPDFEntity(pdfEntity: PDFDTO) throws {
        do {
            try realm.write {
                realm.add(pdfEntity)
            }
        } catch {
            throw RepositoryError.creationFailed
        }
    }

    func updatePDFEntity(pdfEntity: PDFDTO) throws {
        do {
            try realm.write {
                realm.add(pdfEntity, update: .modified)
            }
        } catch {
            throw RepositoryError.updateFailed
        }
    }

    func deletePDFEntity(pdfEntity: PDFDTO) throws {
        do {
            try realm.write {
                realm.add(pdfEntity, update: .all)
                realm.delete(pdfEntity)
            }
        } catch {
            throw RepositoryError.deletionFailed
        }
    }
}
