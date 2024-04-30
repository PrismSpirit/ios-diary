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
        setConstraints()
        loadDiary()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
    }
    
    func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadDiary() {
        let fileName = "sample"
        
        guard let asset = NSDataAsset.init(name: fileName) else {
            return
        }
        
        let jsonDecoder = JSONDecoder()

        do {
            let tempData = try jsonDecoder.decode([Diary].self, from: asset.data)
            diaries = tempData
        } catch {
            print(error.localizedDescription)
        }
    }
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
        
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(diaries[indexPath.row].createdAt))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        cell.createdAtLabel.text = dateFormatter.string(from: date)
        
        return cell
    }
}
