//
//  PDFListViewModel.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/10.
//

import UIKit

struct PDFListViewModelAction {
    let showAddAlert: (UIAlertController) -> Void
    let showFailAlert: (String) -> Void
    let showPDFDetailView: (Int) -> Void
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
    private let repository: RealmRepository
    private let actions: PDFListViewModelAction
    @Published private var pdfDatas: [PDFData] = []
    
    // MARK: - Life Cycle
    init(repository: RealmRepository,
         actions: PDFListViewModelAction
    ) {
        self.repository = repository
        self.actions = actions
        
        loadPDFData()
    }
    
    // MARK: - OUTPUT
    var pdfDatasPublisher: Published<[PDFData]>.Publisher { $pdfDatas }
}

// MARK: - Load Data
extension DefaultPDFListViewModel {
    private func loadPDFData() {
        pdfDatas = repository.readAllPDFEntities()
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
                self?.actions.showFailAlert("Please enter Title and URL.")
                return
            }
            
            if title == "" || urlString == "" {
                return
            }
            
            do {
                try repository.createPDFEntity(title: title, url: url)
                loadPDFData()
            } catch {
                self.actions.showFailAlert(error.localizedDescription)
            }
        }
        
        [cancelAction, addAction].forEach {
            alert.addAction($0)
        }
        
        actions.showAddAlert(alert)
    }
    
    func deleteItem(at index: Int) {
        let deletePDFData = pdfDatas[index]
        
        do {
            try repository.deletePDFEntity(pdfData: deletePDFData)
            loadPDFData()
        } catch {
            actions.showFailAlert(error.localizedDescription)
        }
    }
    
    func selectItem(at index: Int) {
        actions.showPDFDetailView(index)
    }
}
