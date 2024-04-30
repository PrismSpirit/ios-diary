//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by prism, gama on 4/30/24.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    static let identifier = "DiaryTableViewCell"
    
    private let cellTopPadding: CGFloat = 5
    private let cellBottomPadding: CGFloat = -5
    private let cellLeftPadding: CGFloat = 15
    private let cellRightPadding: CGFloat = -15
    private let cellSpacing: CGFloat = 0
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    let bodyStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        contentView.addSubview(cellStackView)
        
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(bodyStackView)
        
        bodyStackView.addArrangedSubview(createdAtLabel)
        bodyStackView.addArrangedSubview(bodyLabel)
        createdAtLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellTopPadding),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: cellBottomPadding),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellLeftPadding),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: cellRightPadding),
        ])
    }
}
