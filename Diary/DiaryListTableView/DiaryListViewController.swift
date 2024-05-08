//
//  Diary - DiaryListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    lazy var viewModel = DiaryListViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigation()
        setupUI()
        initializeViewModel()
        setBindings()
    }
    
    func initializeViewModel() {
        viewModel.requestFetchData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
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
    
    private func configureNavigation() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, 
                                                            target: self,
                                                            action: #selector(deleteDiary))
//                                                            action: #selector(addDiary))
//                                                            action: #selector(updateDiary))
    }
    
    @objc private func updateDiary() {
        viewModel.modifyDiary(index: Int.random(in: 0..<viewModel.diaries.count))
    }
    
    @objc private func deleteDiary() {
        viewModel.deleteDiary(index: 0)
    }
    
    @objc private func addDiary() {
        viewModel.addDiary()
        let detailViewController = DiaryListDetailViewController(viewModel: viewModel.getLatestCellViewModel())
        detailViewController.configureCompoonents()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func setBindings() {
        viewModel.didChangeDiaries = { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DiaryListDetailViewController(viewModel: viewModel.getCellViewModel(index: indexPath.row))
        detailViewController.configureCompoonents()
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.reuseIdentifier, for: indexPath) as? DiaryTableViewCell else { return UITableViewCell() }
        
        let cellViewModel = viewModel.getCellViewModel(index: indexPath.row)
        cell.configureComponents(viewModel: cellViewModel)
        
        return cell
    }
}
