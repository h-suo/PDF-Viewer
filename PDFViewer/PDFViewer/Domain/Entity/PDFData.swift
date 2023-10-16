//
//  PDFData.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import Foundation

struct PDFData: Hashable {
    let id: UUID
    var title: String
    var url: URL
    var bookMark: [Int: Bool]
    var memo: [Int: String]
    
    init(id: UUID = UUID(), title: String, url: URL, bookMark: [Int: Bool] = [:], memo: [Int: String] = [:]) {
        self.id = id
        self.title = title
        self.url = url
        self.bookMark = bookMark
        self.memo = memo
    }
}
