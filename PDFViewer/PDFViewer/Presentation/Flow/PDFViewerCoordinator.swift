//
//  PDFViewerCoordinator.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/11.
//

import UIKit

final class PDFViewerCoordinator {
    
    // MARK: - Private Property
    private var presenter: UINavigationController
    private lazy var pdfViewerUseCase = DefaultPDFViewerUseCase()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    // MARK: - Life Cycle
    func start() {
        let pdfListViewController = makePDFListViewController()
        
        presenter.setViewControllers([pdfListViewController], animated: true)
    }
    
    // MARK: - Make Function
    private func makePDFListViewController() -> PDFListViewController {
        let pdfListViewModel = makePDFListViewModel()
        
        return PDFListViewController(viewModel: pdfListViewModel)
    }
    
    private func makePDFListViewModel() -> PDFListViewModel {
        let pdfListViewModelAction = PDFListViewModelAction(showAddAlert: showAddAlert,
                                                            showFailAlert: showFailAlert)
        
        return DefaultPDFListViewModel(useCase: pdfViewerUseCase, actions: pdfListViewModelAction)
    }
    
    // MARK: - Actions
    private func showAddAlert(alert: UIAlertController) {
        presenter.present(alert, animated: true)
    }
    
    private func showFailAlert(message: String) {
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .cancel)
        alert.addAction(okAction)
        
        presenter.present(alert, animated: true)
    }
}
