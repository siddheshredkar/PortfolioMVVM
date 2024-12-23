//
//  HoldingViewModel.swift
//  SiddheshDemo
//
//  Created by Siddhesh Redkar on 23/12/24.
//

import Foundation
import UIKit

class HoldingViewModel {
    let symbol: String
    let ltp: String
    let quantity: String
    let pnl: String
    let pnlColor: UIColor

    init(userHolding: UserHolding?) {
        // Use default values or gracefully handle nil
        self.symbol = userHolding?.symbol ?? "N/A"
        
        if let ltpValue = userHolding?.ltp {
            self.ltp = String(format: "%.2f", ltpValue)
        } else {
            self.ltp = "-"
        }
        
        if let quantityValue = userHolding?.quantity {
            self.quantity = "\(quantityValue)"
        } else {
            self.quantity = "-"
        }
        
        // Handle optional values for pnl calculation
        if let ltp = userHolding?.ltp, let quantity = userHolding?.quantity, let avgPrice = userHolding?.avgPrice {
            let currentValue = ltp * Double(quantity)
            let investmentValue = avgPrice * Double(quantity)
            let pnlValue = currentValue - investmentValue
            self.pnl = String(format: "%.2f", pnlValue)
            self.pnlColor = PortfolioViewModel.getColor(for: pnlValue)
        } else {
            self.pnl = "-"
            self.pnlColor = .gray
        }
    }
}

