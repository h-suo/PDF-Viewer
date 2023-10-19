//
//  DIContainer.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import UIKit

final class DIContainer {
    
    // MARK: - Make ViewController
    func makePDFListViewController() -> PDFListViewController {
        let pdfListViewModel = makePDFListViewModel()
        
        return PDFListViewController(viewModel: pdfListViewModel)
    }
    
    func makePDFDetailViewController(index: Int) -> PDFDetailViewController {
        let pdfDetailViewModel = makePDFDetailViewModel(index: index)
        let pdfDetailViewController = PDFDetailViewController(viewModel: pdfDetailViewModel)
        
        return pdfDetailViewController
    }
    
    func makePDFMemoViewController(text: String, index: Int) -> PDFMemoViewController {
        return PDFMemoViewController(memo: text, index: index)
    }
    
    // MARK: - Make ViewModel
    private func makePDFListViewModel() -> PDFListViewModel {
        return DefaultPDFListViewModel(repository: RealmRepository.shared)
    }
    
    private func makePDFDetailViewModel(index: Int) -> PDFDetailViewModel {
        return DefaultPDFDetailViewModel(repository: RealmRepository.shared, index: index)
    }
}
