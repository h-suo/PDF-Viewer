//
//  PDFListViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import UIKit
import Combine

struct PDFListViewModelAction {
    let showAddAlert: (UIAlertController) -> Void
}

protocol PDFListViewModelInput {
    func viewDidLoad()
    func tapAddButton()
    func deleteItem(at index: Int)
    func selectItem(at index: Int)
}

protocol PDFListViewModelOutput {
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { get }
}

typealias PDFListViewModel = PDFListViewModelInput & PDFListViewModelOutput

final class DefaultPDFListViewModel: PDFListViewModel {
    
    // MARK: - Private Property
    private let useCase: PDFViewerUseCase
    private let actions: PDFListViewModelAction
    private var cancelables: [AnyCancellable] = []
    @Published private var pdfDatas: [PDFData] = []
    
    // MARK: - Life Cycle
    init(useCase: PDFViewerUseCase,
         actions: PDFListViewModelAction
    ) {
        self.useCase = useCase
        self.actions = actions
        
        setupBindings()
    }
    
    // MARK: - OUTPUT
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { $pdfDatas }
}

// MARK: - Data Binding
extension DefaultPDFListViewModel {
    private func setupBindings() {
        useCase.pdfDatasPublisher.sink { pdfDatas in
            self.pdfDatas = pdfDatas
        }.store(in: &cancelables)
    }
}

// MARK: - INPUT View event methods
extension DefaultPDFListViewModel {
    func viewDidLoad() { }
    
    func tapAddButton() {
        let alert = UIAlertController(title: "Load PDF", message: "Enter the URL to load the PDF.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter the Title"
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter the URL"
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self,
                  let title = alert.textFields?[0].text,
                  let urlString = alert.textFields?[1].text,
                  let url = URL(string: urlString) else {
                return
            }
            
            useCase.storePDFData(title: title, url: url)
        }
        
        [cancelAction, addAction].forEach {
            alert.addAction($0)
        }
        
        actions.showAddAlert(alert)
    }
    
    func deleteItem(at index: Int) {
        
    }
    
    func selectItem(at index: Int) {
        
    }
}
