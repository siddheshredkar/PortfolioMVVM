//
//  PortfolioViewController.swift
//  SiddheshDemo
//
//  Created by Siddhesh Redkar on 22/12/24.
//

import UIKit

class PortfolioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var holdingService: HoldingServiceProtocol = HoldingService()
    private let tableView = UITableView()
    private let profitLossView = ProfitLossView()
    private var holdings: [HoldingViewModel] = []
    private var isProfitLossViewExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Portfolio"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupProfitLossView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HoldingCell.self, forCellReuseIdentifier: "HoldingCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToEdges(of: view)
    }
    
    private func setupProfitLossView() {
        profitLossView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profitLossView)
        
        NSLayoutConstraint.activate([
            profitLossView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profitLossView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profitLossView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Add tap gesture to toggle expand/collapse
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleProfitLossView))
        profitLossView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleProfitLossView() {
        isProfitLossViewExpanded.toggle()
        UIView.animate(withDuration: 0.5) {
            self.profitLossView.constraints.first(where: { $0.firstAttribute == .height })?.constant = self.isProfitLossViewExpanded ? 250 : 100
            self.tableView.contentInset.bottom = self.isProfitLossViewExpanded ? 500 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    //offline test
//    private func loadData() {
//        holdingService.readLocalJSONFile(forName: "userHolding") { [weak self] (userHoldings, err) in
//            if let err = err {
//                print("Failed to fetch holdings:", err)
//                return
//            }
//            guard let userHoldings = userHoldings else {
//                print("Holdings are empty")
//                return
//            }
//            self?.holdings = userHoldings.map { HoldingViewModel(userHolding: $0) }
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//                self?.profitLossView.portfolioViewModel = PortfolioViewModel(userHoldings: userHoldings)
//            }
//        }
//    }
    
    //online
    private func loadData() {
        holdingService.fetchUserHoldings { [weak self] (userHoldings, err) in
            if let err = err {
                print("Failed to fetch holdings:", err)
                return
            }
            guard let userHoldings = userHoldings else {
                print("Holdings are empty")
                return
            }
            self?.holdings = userHoldings.map { HoldingViewModel(userHolding: $0) }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.profitLossView.portfolioViewModel = PortfolioViewModel(userHoldings: userHoldings)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HoldingCell", for: indexPath) as! HoldingCell
        cell.configure(with: holdings[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
