//
//  PDFDataError.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import Foundation

enum PDFDataError: LocalizedError {
    case invalidURL
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        }
    }
}
