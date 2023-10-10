//
//  PDFListViewController.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/09.
//

import UIKit

final class PDFListViewController: UIViewController {
    
    // MARK: - Private Property
    private var collectionView: UICollectionView?
    
    // MARK: - View Event
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureUI()
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
        collectionView?.backgroundColor = .systemFill
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
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
