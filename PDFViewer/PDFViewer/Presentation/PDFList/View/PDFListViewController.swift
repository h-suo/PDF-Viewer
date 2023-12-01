//
//  PDFListViewController.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/09.
//

import Combine
import UIKit

final class PDFListViewController: UIViewController {
  
  // MARK: - Private Property
  private var collectionView: UICollectionView?
  private var dataSource: UICollectionViewDiffableDataSource<Section, PDFData>?
  
  private let viewModel: PDFListViewModel
  private var cancellables: [AnyCancellable]
  
  // MARK: - Life Cycle
  init(viewModel: PDFListViewModel) {
    self.viewModel = viewModel
    self.cancellables = []
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUIObject()
    configureDataSource()
    configureUI()
    bindingPDFData()
    bindingSearchPDFData()
  }
}

// MARK: - Data Binding
extension PDFListViewController {
  private func bindingPDFData() {
    viewModel.pdfDatasPublisher.sink { pdfDatas in
      self.loadCollectionView(pdfDatas)
    }.store(in: &cancellables)
  }
  
  private func bindingSearchPDFData() {
    viewModel.searchPDFDatasPublisher.sink { pdfDatas in
      if !pdfDatas.isEmpty {
        self.loadCollectionView(pdfDatas)
      }
    }.store(in: &cancellables)
  }
}

// MARK: - View Event
extension PDFListViewController {
  
  // MARK: - Add PDF
  @objc private func tapAddButton() {
    let cancelAction = UIAlertAction(title: NameSpace.cancel, style: .cancel)
    let alert = AlertManager()
      .setTitle(NameSpace.loadPDF)
      .setMessage(NameSpace.enterPDFURL)
      .setStyle(.alert)
      .setAction(cancelAction)
      .setTextField(NameSpace.enterTitle)
      .setTextField(NameSpace.enterURL)
      .buildAlert()
    
    let addAction = UIAlertAction(title: NameSpace.add, style: .default) { [weak self] _ in
      guard let self,
            let title = alert.textFields?[0].text,
            let urlString = alert.textFields?[1].text else {
        self?.presentFailAlert(message: NameSpace.enterTitleAndURL)
        return
      }
      
      do {
        try self.viewModel.storePDF(title: title, urlString: urlString)
      } catch {
        self.presentFailAlert(message: error.localizedDescription)
      }
    }
    
    alert.addAction(addAction)
    
    present(alert, animated: true)
  }
}

// MARK: - Configure UI Object
extension PDFListViewController {
  
  private func configureUIObject() {
    configureCollectionView()
    configureSearchController()
  }
  
  private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
    
    return UICollectionViewCompositionalLayout.list(using: configuration)
  }
  
  private func configureCollectionView() {
    collectionView = UICollectionView(frame: .zero,
                                      collectionViewLayout: makeCollectionViewLayout())
    collectionView?.translatesAutoresizingMaskIntoConstraints = false
    collectionView?.delegate = self
  }
  
  private func configureSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
}

// MARK: - CollectionView DataSource
extension PDFListViewController {
  private func configureDataSource() {
    guard let collectionView else {
      return
    }
    
    let cellResgistration = UICollectionView.CellRegistration<PDFListCell, PDFData>(
      handler: { cell, _, item in
        cell.configureCell(title: item.title, url: item.url.absoluteString)
      }
    )
    
    dataSource = UICollectionViewDiffableDataSource<Section, PDFData>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, item in
        return collectionView.dequeueConfiguredReusableCell(
          using: cellResgistration,
          for: indexPath,
          item: item
        )
      }
    )
  }
  
  private func loadCollectionView(_ pdfDatas: [PDFData]) {
    var snapShot = NSDiffableDataSourceSnapshot<Section, PDFData>()
    snapShot.appendSections([.main])
    snapShot.appendItems(pdfDatas)
    
    dataSource?.apply(snapShot)
  }
}

// MARK: - CollectionView Delegate
extension PDFListViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let PDFDetailViewController = DIContainer().makePDFDetailViewController(index: indexPath.row)
    
    navigationController?.pushViewController(PDFDetailViewController, animated: true)
    
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
  private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
    guard let indexPath else {
      return nil
    }
    
    let deleteAction = UIContextualAction(
      style: .destructive,
      title: NameSpace.delete,
      handler: { [weak self] _, _, completion in
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
    )
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}

// MARK: - SearchResults Updating
extension PDFListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text?.lowercased() else {
      return
    }
    
    viewModel.searchPDF(text)
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
    let addButton = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(tapAddButton)
    )
    
    navigationItem.rightBarButtonItem = addButton
    navigationItem.title = NameSpace.pdfViewer
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
