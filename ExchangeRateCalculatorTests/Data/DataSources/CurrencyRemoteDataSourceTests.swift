//
//  CurrencyRemoteDataSourceTests.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation
import XCTest
@testable import ExchangeRateCalculator

class CurrencyRemoteDataSourceTests: XCTestCase {
	private var currencyService: StubCurrencyService!
	private var dataSource: CurrencyRemoteDataSourceImpl!
	private let currencyModel = CurrencyModel(
		remittanceCountry: "USD",
		timestamp: "2022-02-23T00:00:00Z",
		recipientCoutries: [
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "KRW", mid: 1192.9398794964),
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "JPY", mid: 115.0967667032),
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "PHP", mid: 51.3268409469)
		])
	
	override func setUpWithError() throws {
		currencyService = StubCurrencyService(currencyModel: currencyModel)
		dataSource = CurrencyRemoteDataSourceImpl(service: currencyService)
	}
	
	func test_shouldReturnCurrencyModelWhenTheResponseIsSuccessful() {
		let expect = currencyModel
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.success(response) = result else {
				fatalError()
			}
			XCTAssertEqual(response, expect)
		}
	}
}
