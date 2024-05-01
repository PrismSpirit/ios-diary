//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private var diaries: [Diary] = []
    
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
        loadDiary()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func loadDiary() {
        guard let asset = NSDataAsset.init(name: Constants.jsonFileName) else {
            return
        }
        
        do {
            diaries = try JSONDecoder().decode([DiaryDTO].self, from: asset.data).map { $0.toModel() }
        } catch let decodingError as DecodingError {
            AlertHelper.showAlert(title: decodingError.localizedDescription,
                                  message: nil,
                                  type: .onlyConfirm,
                                  viewController: self)
        } catch {
            AlertHelper.showAlert(title: error.localizedDescription,
                                  message: nil,
                                  type: .onlyConfirm,
                                  viewController: self)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, 
                                                            target: self,
                                                            action: #selector(addDiary))
    }
    
    @objc func addDiary() {
        AlertHelper.showAlert(title: "일기장 추가",
                              message: nil,
                              type: .confirmAndCancel,
                              viewController: self)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DiaryListDetailViewController(diary: diaries[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier,
                                                       for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let diary = diaries[indexPath.row]
        cell.updateComponents(with: diary)
        
        return cell
    }
}
