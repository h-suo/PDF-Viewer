//
//  PageNumberView.swift
//  PDFViewer
//
//  Created by Erick on 2023/11/27.
//

import UIKit

final class PageNumberView: UIView {
    
    // MARK: - Private Property
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .systemBackground
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.masksToBounds = true
        layer.cornerRadius = 4
    }
}

// MARK: - Interface
extension PageNumberView {
    func configurePageNumber(_ text: String?) {
        pageLabel.text = text
    }
}

// MARK: - Configure UI
extension PageNumberView {
    private func configureUI() {
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        backgroundColor = .systemFill
        
        addSubview(pageLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            pageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            pageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            pageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            pageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
}
