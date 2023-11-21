//
//  PDFDataTranslater.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/16.
//

import Foundation
import RealmSwift

final class RealmTranslater {
    static func convertToPDFDTO(pdfData: PDFData) -> PDFDTO {
        let pdfDTO = PDFDTO()
        pdfDTO.id = pdfData.id
        pdfDTO.title = pdfData.title
        pdfDTO.url = pdfData.url.absoluteString
        pdfDTO.bookMark.removeAll()
        pdfDTO.bookMark.append(objectsIn: convertToRealmList(bookmarks: pdfData.bookMark))
        pdfDTO.memo.removeAll()
        pdfDTO.memo.append(objectsIn: convertToRealmList(memo: pdfData.memo))
        
        return pdfDTO
    }

    static func convertToPDFData(pdfDTO: PDFDTO) -> PDFData? {
        guard let url = URL(string: pdfDTO.url) else {
            return nil
        }
        
        return PDFData(id: pdfDTO.id,
                       title: pdfDTO.title,
                       url: url,
                       bookMark: convertToDictionary(list: pdfDTO.bookMark),
                       memo: convertToDictionary(list: pdfDTO.memo))
    }

    static func convertToRealmList(bookmarks: [Int: Bool]) -> List<IntBoolPair> {
        let list = List<IntBoolPair>()
        
        for (key, value) in bookmarks {
            let pair = IntBoolPair()
            pair.key = key
            pair.value = value
            list.append(pair)
        }
        
        return list
    }

    static func convertToRealmList(memo: [Int: String]) -> List<IntStringPair> {
        let list = List<IntStringPair>()
        
        for (key, value) in memo {
            let pair = IntStringPair()
            pair.key = key
            pair.value = value
            list.append(pair)
        }
        
        return list
    }

    static func convertToDictionary(list: List<IntBoolPair>) -> [Int: Bool] {
        var dictionary = [Int: Bool]()
        
        for pair in list {
            dictionary[pair.key] = pair.value
        }
        
        return dictionary
    }

    static func convertToDictionary(list: List<IntStringPair>) -> [Int: String] {
        var dictionary = [Int: String]()
        
        for pair in list {
            dictionary[pair.key] = pair.value
        }
        
        return dictionary
    }
}
