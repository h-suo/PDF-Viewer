//
//  PDFData.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import Foundation

struct PDFData: Hashable {
    let id: UUID = UUID()
    var title: String
    var url: URL
    var bookMark: [Int: Bool] = [:]
}
