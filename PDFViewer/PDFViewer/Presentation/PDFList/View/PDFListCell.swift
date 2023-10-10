//
//  PDFListCell.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/09.
//

import UIKit

final class PDFListCell: UICollectionViewListCell {
    
    // MARK: - Static Property
    static let identifier = String(describing: PDFListCell.self)
    
    // MARK: - Private Property
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let docImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "doc")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray
        
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface
extension PDFListCell {
    func configureCell(title: String, url: String) {
        titleLabel.text = title
        urlLabel.text = url
    }
}

// MARK: - Configure UI
extension PDFListCell {
    private func configureUI() {
        configureAccessories()
        configureView()
        configureStackView()
        configureLayout()
    }
    
    private func configureAccessories() {
        accessories.append(.disclosureIndicator())
    }
    
    private func configureView() {
        contentView.addSubview(stackView)
    }
    
    private func configureStackView() {
        [docImageView, labelStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [titleLabel, urlLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
}
