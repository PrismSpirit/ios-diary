//
//  DiaryListDetailViewController.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
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
    
//    private let diary: Diary
//    var titleText: String? = ""
//    var editedDateText: String? = ""
//    var bodyText: String? = ""
//    let viewModel = DiaryListDetailViewModel()
//    let viewModel: DiaryListViewModel
    let viewModel: DiaryListDetailViewModel
    
//    init(diary: Diary) {
//        self.diary = diary
//        super.init(nibName: nil, bundle: nil)
//    }
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
//        title = diary.editedDate.formatted(.defaultDateFormatStyle)
//        textView.text = diary.title + "\n\n" + diary.body
//        if let titleText = titleText, let editedDateText = editedDateText, let bodyText = bodyText {
//            title = editedDateText
//            textView.text = titleText + "\n\n" + bodyText
//        }
//        if let diary = viewModel.diary {
//            title = diary.formatDate()
//            textView.text = diary.title + "\n\n" + diary.body
//        }
        
        configureCompoonents()
        
        let _ = UIResponder.keyboardWillHideNotification
    }
    
    init(viewModel: DiaryListDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureCompoonents() {
        title = viewModel.diary.formatDate()
        textView.text = viewModel.diary.title + "\n\n" + viewModel.diary.body
        textView.becomeFirstResponder()
    }
}
