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
        let pdfListViewModelAction = PDFListViewModelAction(showAddAlert: showAlert,
                                                            showFailAlert: showFailAlert,
                                                            showPDFDetailView: showPDFDetailView)
        
        return DefaultPDFListViewModel(useCase: pdfViewerUseCase, actions: pdfListViewModelAction)
    }
    
    private func makePDFDetailViewController(index: Int) -> PDFDetailViewController {
        let pdfDetailViewModel = makePDFDetailViewModel(index: index)
        let pdfDetailViewController = PDFDetailViewController(viewModel: pdfDetailViewModel)
        
        return pdfDetailViewController
    }
    
    private func makePDFDetailViewModel(index: Int) -> PDFDetailViewModel {
        let pdfDetailViewModelAction = PDFDetailViewModelAction(showBookmarkAlert: showAlert,
                                                                showMemoView: showMemoView)
        
        return DefaultPDFDetailViewModel(useCase: pdfViewerUseCase, index: index, actions: pdfDetailViewModelAction)
    }
    
    // MARK: - Actions
    private func showAlert(alert: UIAlertController) {
        presenter.present(alert, animated: true)
    }
    
    private func showFailAlert(message: String) {
        let failAlert = UIAlertController.makeFailAlert(message: message)
        
        presenter.present(failAlert, animated: true)
    }
    
    private func showPDFDetailView(index: Int) {
        let pdfDetailViewController = makePDFDetailViewController(index: index)
        
        presenter.pushViewController(pdfDetailViewController, animated: true)
    }
    
    private func showMemoView(viewController: UIViewController) {
        presenter.pushViewController(viewController, animated: true)
    }
}
