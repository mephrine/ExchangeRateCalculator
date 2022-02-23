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
		let changedCurrencyModel = [
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "KRW", mid: 1192.9398794964),
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "JPY", mid: 115.0967667032),
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "PHP", mid: 51.3268409469)
		]
		currencyModel = CurrencyModel(
			remittanceCountry: "USD",
			timestamp: "2022-02-23T00:00:00Z",
			recipientCoutries: changedCurrencyModel)
	}
	
	func test_shouldReturnValidModelWhenTheJsonStringIsParsed() throws {
		let jsonData = CurrencyModelFixture.data
		let jsonDecoder = JSONDecoder()
		
		let result = try jsonDecoder.decode(CurrencyModel.self, from: jsonData)
		let expect = currencyModel
		XCTAssertEqual(result, expect)
	}
}

extension CurrencyModel: Equatable {
	public static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
		lhs.timestamp == rhs.timestamp && Set(lhs.recipientCoutries).intersection(Set(rhs.recipientCoutries)).count == lhs.recipientCoutries.count
	}
}

extension CurrencyModel.ChangedCurrencyModel: Hashable, Equatable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.quoteCurrency)
	}
	
	public static func == (lhs: CurrencyModel.ChangedCurrencyModel, rhs: CurrencyModel.ChangedCurrencyModel) -> Bool {
		lhs.mid == rhs.mid && lhs.mid == rhs.mid
	}
}
