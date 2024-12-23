//
//  HoldingCell.swift
//  SiddheshDemo
//
//  Created by Siddhesh Redkar on 22/12/24.
//

import Foundation
import UIKit

class HoldingCell: UITableViewCell {
    private let symbolLabel = UILabel()
    private let quantityLabel = UILabel()
    private let ltpLabel = UILabel()
    private let pnlLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [symbolLabel, quantityLabel, ltpLabel, pnlLabel].forEach { contentView.addSubview($0) }

        symbolLabel.font = .systemFont(ofSize: 16, weight: .bold)
        quantityLabel.font = .systemFont(ofSize: 12 , weight: .medium)
        quantityLabel.textColor = UIColor.gray
        ltpLabel.font = .systemFont(ofSize: 14)
        pnlLabel.font = .systemFont(ofSize: 14)

        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        ltpLabel.translatesAutoresizingMaskIntoConstraints = false
        pnlLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            quantityLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),

            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ltpLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),

            pnlLabel.trailingAnchor.constraint(equalTo: ltpLabel.trailingAnchor),
            pnlLabel.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor)
        ])
    }

    func configure(with holdingViewModel: HoldingViewModel) {
        symbolLabel.text = holdingViewModel.symbol
        quantityLabel.text = "Qty: \(holdingViewModel.quantity)"
        ltpLabel.text = "LTP: \(holdingViewModel.ltp)"
        pnlLabel.text = holdingViewModel.pnl
        pnlLabel.textColor = holdingViewModel.pnlColor
    }

}
