//
//  ProfitLossView.swift
//  SiddheshDemo
//
//  Created by Siddhesh Redkar on 22/12/24.
//

import UIKit

class ProfitLossView: UIView {
    
    var portfolioViewModel: PortfolioViewModel? {
        didSet {
            guard let vm = portfolioViewModel else { return }
            
            currentValueLabel.text = vm.currentValueTitle
            currentValueValueLabel.text = vm.totalCurrentValue
            
            totalInvestmentLabel.text = vm.totalInvestmentTitle
            totalInvestmentValueLabel.text = vm.totalInvestmentValue
            
            todaysProfitLossLabel.text = vm.todayProfitLossTitle
            todaysProfitLossValueLabel.text = vm.todaysPNLValue
            todaysProfitLossValueLabel.textColor = vm.todaysPNLColor
            
            profitLossFooterLabel.text = vm.totalProfitLossTitle
            profitLossFooterValueLabel.text = vm.totalPNLValue
            profitLossFooterValueLabel.textColor = vm.totalPNLColor
        }
    }
    
    var expanded: Bool = false {
        didSet {
            // Toggle visibility of expandable stack view
            expandableStackView.isHidden = !expanded
            expandCollapseButton.setImage(.init(systemName: expanded ? "chevron.down" : "chevron.up"), for: .normal)
        }
    }
    
    private let currentValueLabel = createLabel(fontSize: 12, weight: .medium, textColor: UIColor.gray)
    private let currentValueValueLabel = createLabel(fontSize: 14, weight: .medium, textAlignment: .right,textColor: UIColor.gray)
    private let totalInvestmentLabel = createLabel(fontSize: 12, weight: .medium, textColor: UIColor.gray)
    private let totalInvestmentValueLabel = createLabel(fontSize: 14, weight: .medium, textAlignment: .right,textColor: UIColor.gray)
    private let todaysProfitLossLabel = createLabel(fontSize: 12, weight: .medium, textColor: UIColor.gray)
    private let todaysProfitLossValueLabel = createLabel(fontSize: 14, weight: .medium, textAlignment: .right)
    private let profitLossFooterLabel = createLabel(fontSize: 14, weight: .medium,textColor: UIColor.gray)
    private let profitLossFooterValueLabel = createLabel(fontSize: 14, weight: .medium)
    private let expandCollapseButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.setImage(.init(systemName: "chevron.up"), for: .normal)
        return button
    }()
    
    private lazy var expandableStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            createHorizontalStack(label: currentValueLabel, valueLabel: currentValueValueLabel),
            createHorizontalStack(label: totalInvestmentLabel, valueLabel: totalInvestmentValueLabel),
            createHorizontalStack(label: todaysProfitLossLabel, valueLabel: todaysProfitLossValueLabel)
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profitLossFooterLabel, expandCollapseButton , profitLossFooterValueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [expandableStackView , footerStackView])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemBackground
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
        ])
        profitLossFooterLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        expandableStackView.isHidden = true
        expandCollapseButton.addTarget(self, action: #selector(toggleExpandCollapse), for: .touchUpInside)
        applyShadowAndCorners()
    }
    
    @objc private func toggleExpandCollapse() {
        expanded.toggle()
    }
    
    private func applyShadowAndCorners() {
        layer.cornerRadius = 16
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
    }
    
    private static func createLabel(fontSize: CGFloat, weight: UIFont.Weight, textAlignment: NSTextAlignment = .left, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createHorizontalStack(label: UILabel, valueLabel: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label, valueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
}
