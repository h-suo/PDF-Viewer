//
//  PDFMemoViewController.swift
//  PDFViewer
//
//  Created by Erick on 2023/10/16.
//

import UIKit

protocol PDFMemoViewControllerDelegate: AnyObject {
    func pdfMemoViewController(_ pdfMemoViewController: PDFMemoViewController, takeNotes text: String, noteIndex: Int)
}

final class PDFMemoViewController: UIViewController {
    
    // MARK: - Private Property
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.addObserveKeyboardNotification()
        
        return textView
    }()
    
    private let memo: String?
    private let index: Int
    
    // MARK: - Delegate Property
    weak var delegate: PDFMemoViewControllerDelegate?
    
    // MARK: - Life Cycle
    init(memo: String?, index: Int) {
        self.memo = memo
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Event
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTextView(memo)
    }
    
    @objc private func tapDoneButton() {
        if let text = textView.text {
            delegate?.pdfMemoViewController(self, takeNotes: text, noteIndex: index)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure UI Object
extension PDFMemoViewController {
    private func configureTextView(_ text: String?) {
        textView.text = text
    }
}

// MARK: - Configure UI
extension PDFMemoViewController {
    private func configureUI() {
        configureNavigation()
        configureView()
        configureLayout()
    }
    
    private func configureNavigation() {
        let doneAction = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        
        navigationItem.title = "Memo"
        navigationItem.rightBarButtonItem = doneAction
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
