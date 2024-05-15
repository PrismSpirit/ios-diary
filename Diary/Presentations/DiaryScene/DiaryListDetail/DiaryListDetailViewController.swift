//
//  DiaryListDetailViewController.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import UIKit
import Combine

final class DiaryListDetailViewController: UIViewController {
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.keyboardDismissMode = .interactive
        return textView
    }()
    
    private let viewModel: DiaryListDetailViewModel
    private let output: PassthroughSubject<DiaryListDetailViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(diary: Diary) {
        self.viewModel = DiaryListDetailViewModel(diary: diary, diaryListDetailUseCase: DiaryListDetailUseCase(diaryRepository: DiaryRepository(diaryPersistentStorage: DiaryStorage(coreDataStorage: CoreDataStorage.shared))))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()
        configureNavigation()
        setupUI()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.send(.viewWillAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.body = textView.text
        output.send(.viewWillDisappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func bind() {
        viewModel.transform(input: output.eraseToAnyPublisher())
            .receive(on: RunLoop.main)
            .sink { event in
                switch event {
                case .updateTextView(let body):
                    self.textView.text = body
                case .diaryDidDeleted:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureTextView() {
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.alwaysBounceVertical = true
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "더보기",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(showAlertSheet))
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
    
    @objc private func showAlertSheet() {
        AlertHelper.showActionSheet(title: nil, message: nil, viewController: self) {
            let diaryShareActivityItemSource = DiaryShareActivityItemSource(title: self.viewModel.body)
            self.present(UIActivityViewController(activityItems: [diaryShareActivityItemSource], applicationActivities: nil), animated: true)
        } delete: {
            self.output.send(.diaryDeleteActionSheetDidTouchUp(id: self.viewModel.id))
        }
    }
}

extension DiaryListDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
