//
//  Diary - DiaryListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine

final class DiaryListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: DiaryListViewModel
    private let output: PassthroughSubject<DiaryListViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureTableView()
        setupUI()
        bind()
    }
    
    init(viewModel: DiaryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        output.send(.viewIsAppearing)
    }
    
    private func bind() {
        viewModel.transform(input: output.eraseToAnyPublisher())
            .receive(on: RunLoop.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .diaryDidLoad:
                    self.tableView.reloadData()
                case .diaryDidAdd(let diary):
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    let diaryDetailViewController = AppDIContainer.shared.makeDiaryDetailViewController(diary: diary, isEditModeActivated: true)
                    self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
                case .diaryDidDelete(let index):
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureNavigation() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(handleDiaryAddEvent))
    }
    
    @objc private func handleDiaryAddEvent() {
        output.send(.diaryAddButtonDidTouchUp)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiaryTableViewCell.self,
                           forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let diary = self.viewModel.diaries[safeIndex: indexPath.row] else { return }
        let diaryDetailViewController = AppDIContainer.shared.makeDiaryDetailViewController(diary: diary)
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let diary = self.viewModel.diaries[safeIndex: indexPath.row] else { return nil }
        
        let shareAction = UIContextualAction(style: .normal,
                                       title: nil) { _, _, completion in
            let textToShare = diary.body
            self.present(UIActivityViewController(activityItems: [textToShare], applicationActivities: nil), animated: true)
            
            completion(true)
        }
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let deleteAction = UIContextualAction(style: .destructive,
                                        title: nil) { _, _, completion in
            self.output.send(.diaryDeleteButtonDidTouchUp(index: indexPath.row))
            
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeActionConfiguration
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.diaries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let diary = viewModel.diaries[safeIndex: indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = AppDIContainer.shared.makeDiaryCellViewModel(diary: diary)
        
        cell.updateComponents(with: cellViewModel)
        
        return cell
    }
}
