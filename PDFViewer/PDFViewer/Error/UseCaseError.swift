//
//  UseCaseError.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import Foundation

enum UseCaseError: LocalizedError {
    case storeDataFailed
    case addBookmarkFailed
    case deleteBookmarkFailed
    case storeMemoFailed
    
    public var errorDescription: String? {
        switch self {
        case .storeDataFailed:
            return "Data store operation failed."
        case .addBookmarkFailed:
            return "Add bookmark operation failed."
        case .deleteBookmarkFailed:
            return "Delete bookmark operation failed."
        case .storeMemoFailed:
            return "Memo store operation failed."
        }
    }
}
