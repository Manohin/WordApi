//
//  WordCell.swift
//  WordApi
//
//  Created by Alexey Manokhin on 31.10.2023.
//

import UIKit

final class WordCell: UITableViewCell {
    
    static let id = "WordCell"
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.9446846843, green: 0.9776129127, blue: 0.9872179627, alpha: 1)
        [valueLabel, dateLabel].forEach({
            addSubview($0)
        })
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            valueLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}
