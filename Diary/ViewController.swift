//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    var diaries: [Diary] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func loadDiary() {
        guard let asset = NSDataAsset.init(name: Constants.jsonFileName) else {
            return
        }
        
        do {
            let tempData = try JSONDecoder().decode([Diary].self, from: asset.data)
            diaries = tempData
        } catch let decodingError as DecodingError {
            AlertHelper.showAlert(title: decodingError.localizedDescription, message: nil, type: .onlyConfirm, viewController: self)
        } catch {
            AlertHelper.showAlert(title: error.localizedDescription, message: nil, type: .onlyConfirm, viewController: self)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiary))
    }
    
    @objc func addDiary() {
        AlertHelper.showAlert(title: "일기장 추가", message: nil, type: .confirmAndCancel, viewController: self)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextController = UIViewController()
        navigationController?.pushViewController(nextController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.titleLabel.text = diaries[indexPath.row].title
        cell.bodyLabel.text = diaries[indexPath.row].body
        
        let date = Date(timeIntervalSince1970: TimeInterval(diaries[indexPath.row].createdAt))
        cell.createdAtLabel.text = DateFormatter.formatDate(date)
        
        return cell
    }
}
