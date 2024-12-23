//
//  PortfolioViewModelTests.swift
//  SiddheshDemoTests
//
//  Created by Siddhesh Redkar on 23/12/24.
//


import XCTest
@testable import SiddheshDemo

class PortfolioViewModelTests: XCTestCase {
    
    // MARK: - Tests for HoldingViewModel
    func testHoldingViewModel_withValidData() {
        // Arrange
        let holding = UserHolding(symbol: "AAPL", quantity: 10, ltp: 170.0, avgPrice: 150.0, close: 180.0)
        
        // Act
        let viewModel = HoldingViewModel(userHolding: holding)
        
        // Assert
        XCTAssertEqual(viewModel.symbol, "AAPL")
        XCTAssertEqual(viewModel.ltp, "170.00")
        XCTAssertEqual(viewModel.quantity, "10")
        XCTAssertEqual(viewModel.pnl, "200.00") // (170 * 10) - (150 * 10)
        XCTAssertEqual(viewModel.pnlColor, UIColor.green)
    }
    
    func testHoldingViewModel_withMissingData() {
        // Arrange
        let holding = UserHolding(symbol: nil, quantity: nil, ltp: nil, avgPrice: nil, close: nil)
        
        // Act
        let viewModel = HoldingViewModel(userHolding: holding)
        
        // Assert
        XCTAssertEqual(viewModel.symbol, "N/A")
        XCTAssertEqual(viewModel.ltp, "-")
        XCTAssertEqual(viewModel.quantity, "-")
        XCTAssertEqual(viewModel.pnl, "-")
        XCTAssertEqual(viewModel.pnlColor, UIColor.gray)
    }
    
    func testHoldingViewModel_partialData() {
        // Arrange
        let holding = UserHolding(symbol: "TSLA", quantity: 10, ltp: 900.0, avgPrice: nil, close: nil)
        
        // Act
        let viewModel = HoldingViewModel(userHolding: holding)
        
        // Assert
        XCTAssertEqual(viewModel.symbol, "TSLA")
        XCTAssertEqual(viewModel.ltp, "900.00")
        XCTAssertEqual(viewModel.quantity, "10")
        XCTAssertEqual(viewModel.pnl, "-")
        XCTAssertEqual(viewModel.pnlColor, UIColor.gray)
    }
    
    // MARK: - Tests for PortfolioViewModel
    func testPortfolioViewModel_withMultipleHoldings() {
        // Arrange
        let holdings: [UserHolding?] = [
            UserHolding(symbol: "AAPL", quantity: 10, ltp: 170.0, avgPrice: 150.0, close: 180.0),
            UserHolding(symbol: "GOOGL", quantity: 5, ltp: 2800.0, avgPrice: 2600.0, close: 2900.0),
            UserHolding(symbol: "MSFT", quantity: nil, ltp: nil, avgPrice: nil, close: nil)
        ]
        
        // Act
        let viewModel = PortfolioViewModel(userHoldings: holdings)
        
        // Assert
        XCTAssertEqual(viewModel.totalCurrentValue, "15700.00") // (170 * 10) + (2800 * 5)
        XCTAssertEqual(viewModel.totalInvestmentValue, "14500.00") // (150 * 10) + (2600 * 5)
        XCTAssertEqual(viewModel.totalPNLValue, "1200.00") // 15700 - 16000
       // XCTAssertEqual(viewModel.totalPNLColor, UIColor.red)
        XCTAssertEqual(viewModel.todaysPNLValue, "600.00") // (180 - 170) * 10 + (2900 - 2800) * 5
        XCTAssertEqual(viewModel.todaysPNLColor, UIColor.green)
        XCTAssertEqual(viewModel.holdings.count, 3) // One holding is nil and ignored
    }
    
    func testPortfolioViewModel_withEmptyHoldings() {
        // Arrange
        let holdings: [UserHolding?] = []
        
        // Act
        let viewModel = PortfolioViewModel(userHoldings: holdings)
        
        // Assert
        XCTAssertEqual(viewModel.totalCurrentValue, "-")
        XCTAssertEqual(viewModel.totalInvestmentValue, "-")
        XCTAssertEqual(viewModel.totalPNLValue, "-")
        XCTAssertEqual(viewModel.totalPNLColor, UIColor.gray)
        XCTAssertEqual(viewModel.todaysPNLValue, "-")
        XCTAssertEqual(viewModel.todaysPNLColor, UIColor.gray)
        XCTAssertEqual(viewModel.holdings.count, 0)
    }
    
    func testPortfolioViewModel_withNilHoldings() {
        // Arrange
        let holdings: [UserHolding?] = [nil, nil]
        
        // Act
        let viewModel = PortfolioViewModel(userHoldings: holdings)
        
        // Assert
        XCTAssertEqual(viewModel.totalCurrentValue, "-") // Properly handles nil
        XCTAssertEqual(viewModel.totalInvestmentValue, "-")
        XCTAssertEqual(viewModel.totalPNLValue, "-")
        XCTAssertEqual(viewModel.totalPNLColor, UIColor.gray)
        XCTAssertEqual(viewModel.todaysPNLValue, "-")
        XCTAssertEqual(viewModel.todaysPNLColor, UIColor.gray)
        XCTAssertEqual(viewModel.holdings.count, 0) // No valid holdings
    }

}
