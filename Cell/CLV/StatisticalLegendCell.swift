//
//  StatisticalLegendCell.swift
//  CapybaraApp
//
//  Created by Phạm Quý Thịnh on 12/6/25.
//


import UIKit

class StatisticalLegendCell: UICollectionViewCell {
    let dot = UIView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.layer.cornerRadius = 5
        contentView.addSubview(dot)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.EduVICWANTHandPre(14)
        label.numberOfLines = 1
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 20),
            dot.heightAnchor.constraint(equalToConstant: 20),
            dot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
