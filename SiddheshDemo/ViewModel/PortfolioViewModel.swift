//
//  PortfolioViewModel.swift
//  SiddheshDemo
//
//  Created by Siddhesh Redkar on 23/12/24.
//

import Foundation
import UIKit

class PortfolioViewModel {
    // Aggregated Portfolio Fields
    let currentValueTitle = "Current value*"
    let totalInvestmentTitle = "Total investment*"
    let todayProfitLossTitle = "Today's Profit & Loss*"
    let totalProfitLossTitle = "Profit & Loss*"

    let totalCurrentValue: String
    let totalInvestmentValue: String
    let totalPNLValue: String
    let totalPNLColor: UIColor
    let todaysPNLValue: String
    let todaysPNLColor: UIColor
    
    // Individual Holdings
    let holdings: [HoldingViewModel]

    init(userHoldings: [UserHolding?]) {
        // Calculate aggregated values
        let calculatedValue = PortfolioViewModel.getCalculatedValue(userHoldings: userHoldings)
        
        if let totalCurrent = calculatedValue.totalCurrentValue {
            totalCurrentValue = String(format: "%.2f", totalCurrent)
        } else {
            totalCurrentValue = "-"
        }
        
        if let totalInvestment = calculatedValue.totalInvestmentValue {
            totalInvestmentValue = String(format: "%.2f", totalInvestment)
        } else {
            totalInvestmentValue = "-"
        }
        
        if let totalPNL = calculatedValue.totalPNL {
            totalPNLValue = String(format: "%.2f", totalPNL)
            totalPNLColor = PortfolioViewModel.getColor(for: totalPNL)
        } else {
            totalPNLValue = "-"
            totalPNLColor = .gray
        }
        
        if let todaysPNL = calculatedValue.todaysPNL {
            todaysPNLValue = String(format: "%.2f", todaysPNL)
            todaysPNLColor = PortfolioViewModel.getColor(for: todaysPNL)
        } else {
            todaysPNLValue = "-"
            todaysPNLColor = .gray
        }
        
        // Create ViewModels for individual holdings
        holdings = userHoldings.compactMap { holding in
            guard let holding = holding else { return nil }
            return HoldingViewModel(userHolding: holding)
        }
    }
    
    static func getCalculatedValue(userHoldings: [UserHolding?]) -> (totalCurrentValue: Double?, totalInvestmentValue: Double?, todaysPNL: Double?, totalPNL: Double?) {
        guard !userHoldings.isEmpty else {
            return (nil, nil, nil, nil)
        }
        
        var totalCurrentValue: Double = 0
        var totalInvestmentValue: Double = 0
        var todaysPNL: Double = 0
        var validHoldings = false
        
        for holding in userHoldings {
            guard let quantity = holding?.quantity, let ltp = holding?.ltp, let avgPrice = holding?.avgPrice else {
                continue
            }
            validHoldings = true
            let currentValueForHolding = ltp * Double(quantity)
            let investmentValueForHolding = avgPrice * Double(quantity)
            totalCurrentValue += currentValueForHolding
            totalInvestmentValue += investmentValueForHolding
            
            if let close = holding?.close {
                let closeLTPDiff = (Double(close) - ltp) * Double(quantity)
                todaysPNL += closeLTPDiff
            }
        }
        
        if !validHoldings {
            return (nil, nil, nil, nil) // No valid data in holdings
        }
        
        let totalPNL = totalCurrentValue - totalInvestmentValue
        return (totalCurrentValue, totalInvestmentValue, todaysPNL, totalPNL)
    }

    
    static func getColor(for value: Double) -> UIColor {
        if value > 0 {
            return .green // Profit
        } else if value < 0 {
            return .red // Loss
        } else {
            return .gray // Neutral
        }
    }
}
