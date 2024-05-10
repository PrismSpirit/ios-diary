//
//  Diary - DiaryListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine

final class DiaryListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel = DiaryListViewModel(diaryListUseCase: DiaryListUseCase(diaryRepository: DiaryRepository(diaryPersistentStorage: DiaryStorage(coreDataStorage: CoreDataStorage.shared))))
    private let output: PassthroughSubject<DiaryListViewModel.Input, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureTableView()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.send(.viewWillAppear)
    }
    
    private func bind() {
        viewModel.transform(input: output.eraseToAnyPublisher()).sink { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .loadDiaryDidFail(let error):
                break
            case .loadDiaryDidSuccess:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .addDiaryDidSuccess:
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integersIn: 0..<self.tableView.numberOfSections), with: .automatic)
                }
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
        output.send(.diaryAddDidTouchUp)
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
        output.send(.diaryDidSelect(index: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal,
                                       title: nil) { [weak self] _, _, completion in
            self?.output.send(.diaryShareDidTouchUp(index: indexPath.row))
            completion(true)
        }
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let deleteAction = UIContextualAction(style: .destructive,
                                        title: nil) { [weak self] _, _, completion in
            guard let self else { return }
            
            let diaryIDOfWillBeDeleted = self.viewModel.items[indexPath.row].id
            
            tableView.performBatchUpdates {
                self.viewModel.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } completion: { _ in
                self.output.send(.diaryDeleteDidTouchUp(id: diaryIDOfWillBeDeleted))
            }
            
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.items[indexPath.row]
        
        cell.updateComponents(with: cellViewModel)
        
        return cell
    }
}
