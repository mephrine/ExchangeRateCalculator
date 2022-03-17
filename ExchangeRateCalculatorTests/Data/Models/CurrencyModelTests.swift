//
//  CurrencyModelTests.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation
import XCTest
@testable import ExchangeRateCalculator

class CurrencyModelTests: XCTestCase {
	private var currencyModel: CurrencyModel!
	
	override func setUpWithError() throws {
		let changedCurrencyModel = CurrencyModel.ChangedCurrencyModel(krw: 1192.9398794964, jpy: 115.0967667032, php: 51.3268409469)
		currencyModel = CurrencyModel(
			timestamp: Date(timeIntervalSince1970: 1545881647),
			quotes: changedCurrencyModel)
	}
	
	func test_shouldReturnValidModelWhenTheJsonStringIsParsed() throws {
		let jsonData = CurrencyModelFixture.data
		
		let result = try JSONDecoder().parse(from: jsonData, to: CurrencyModel.self)
		let expect = currencyModel
		XCTAssertEqual(result, expect)
	}
	
	func test_shouldReturnNilWhenTheJsonDataIsInvalid() {
		let jsonData = "invalid".data(using: .utf8)
		let jsonDecoder = JSONDecoder()
		
		let result = try? jsonDecoder.decode(CurrencyModel.self, from: jsonData!)
		XCTAssertEqual(result, nil)
	}
}

extension CurrencyModel: Equatable {
	public static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
		lhs.timestamp == rhs.timestamp && lhs.quotes == rhs.quotes
	}
}

extension CurrencyModel.ChangedCurrencyModel: Hashable, Equatable {
	public static func == (lhs: CurrencyModel.ChangedCurrencyModel, rhs: CurrencyModel.ChangedCurrencyModel) -> Bool {
		lhs.krw == rhs.krw && lhs.jpy == rhs.jpy &&  lhs.php == rhs.php
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.hashValue)
	}
}
