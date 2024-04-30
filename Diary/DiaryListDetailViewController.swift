//
//  DiaryListDetailViewController.swift
//  Diary
//
//  Created by Jaehun Lee on 4/30/24.
//

import UIKit

final class DiaryListDetailViewController: UIViewController {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.keyboardDismissMode = .interactive
        return textView
    }()
    
    private let date: Date
    private let memo: String
    private let defaultDateFormatStyle = Date.FormatStyle(
        date: .abbreviated,
        time: .omitted,
        locale: .autoupdatingCurrent,
        calendar: .autoupdatingCurrent,
        timeZone: .autoupdatingCurrent
    )
    
    init(date: Date, memo: String) {
        self.date = date
        self.memo = memo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        title = date.formatted(defaultDateFormatStyle)
        textView.text = memo
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
                        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
