//
//  PDFListViewController.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/09.
//

import UIKit
import Combine

final class PDFListViewController: UIViewController {
    
    // MARK: - Private Property
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, PDFData>?
    
    private var cancellables: [AnyCancellable] = []
    private let viewModel: PDFListViewModel
    
    // MARK: - Life Cycle
    init(viewModel: PDFListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Event
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
        configureUI()
        setupBindings()
    }
    
    @objc private func tapAddButton() {
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
                  let urlString = alert.textFields?[1].text else {
                self?.presentFailAlert(message: "Please enter Title and URL.")
                return
            }
            
            do {
                try self.viewModel.storePDF(title: title, urlString: urlString)
            } catch {
                self.presentFailAlert(message: error.localizedDescription)
            }
        }
        
        [cancelAction, addAction].forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true)
    }
}

// MARK: - Data Binding
extension PDFListViewController {
    private func setupBindings() {
        viewModel.pdfDatasPublisher.sink { [weak self] pdfDatas in
            guard let self else {
                return
            }
            
            self.loadCollectionView(pdfDatas)
        }.store(in: &cancellables)
    }
}

// MARK: - Configure UI Object
extension PDFListViewController {
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.delegate = self
    }
}

// MARK: - CollectionView DataSource
extension PDFListViewController {
    private func configureDataSource() {
        guard let collectionView else {
            return
        }
        
        let cellResgistration = UICollectionView.CellRegistration<PDFListCell, PDFData> { cell, _, item in
            cell.configureCell(title: item.title, url: item.url.absoluteString)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PDFData>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellResgistration, for: indexPath, item: item)
        })
    }
    
    private func loadCollectionView(_ pdfDatas: [PDFData]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, PDFData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(pdfDatas)
        
        self.dataSource?.apply(snapShot)
    }
}

// MARK: - CollectionView Delegate
extension PDFListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let PDFDetailViewController = DIContainer().makePDFDetailViewController(index: indexPath.row)
        
        navigationController?.pushViewController(PDFDetailViewController, animated: true)

        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] _, _, completion in
            guard let self else {
                return
            }
            
            do {
                try self.viewModel.deletePDF(at: indexPath.row)
                completion(true)
            } catch {
                self.presentFailAlert(message: error.localizedDescription)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Configure UI
extension PDFListViewController {
    private func configureUI() {
        configureNavigation()
        configureView()
        configureLayout()
    }
    
    private func configureNavigation() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        
        navigationItem.title = "PDF Viewer"
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureView() {
        guard let collectionView else {
            return
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        guard let collectionView else {
            return
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

// MARK: - Section
extension PDFListViewController {
    private enum Section {
        case main
    }
}
