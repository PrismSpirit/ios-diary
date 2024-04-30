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
    private let cellSpacing: CGFloat = 10
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyStackView)
        
        bodyStackView.addArrangedSubview(createdAtLabel)
        bodyStackView.addArrangedSubview(bodyLabel)
        createdAtLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellLeftPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: cellRightPadding),
            
            bodyStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: cellSpacing),
            bodyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellLeftPadding),
            bodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: cellRightPadding),
            bodyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: cellBottomPadding)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
