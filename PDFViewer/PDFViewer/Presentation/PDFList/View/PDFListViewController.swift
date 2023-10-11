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
        viewModel.tapAddButton()
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
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(PDFListCell.self, forCellWithReuseIdentifier: PDFListCell.identifier)
        collectionView?.delegate = self
    }
}

// MARK: - CollectionView DataSource
extension PDFListViewController {
    private func configureDataSource() {
        guard let collectionView else {
            return
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PDFData>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PDFListCell.identifier, for: indexPath) as? PDFListCell else {
                return UICollectionViewListCell()
            }
            
            cell.configureCell(title: item.title, url: item.url.absoluteString)
            
            return cell
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
        viewModel.selectItem(at: indexPath.row)
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
