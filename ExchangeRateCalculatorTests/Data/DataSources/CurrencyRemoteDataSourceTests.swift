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
	private let fixtureData = CurrencyModelFixture.data
	
	override func setUpWithError() throws {
		let response = HTTPURLResponse(url: URL(string: Environment.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		currencyService = StubCurrencyService(data: fixtureData, urlResponse: response, error: ServerError.invalidURL)
		dataSource = CurrencyRemoteDataSourceImpl(service: currencyService)
	}
	
	func test_shouldReturnCurrencyModelWhenTheResponseIsSuccessful() {
		let expect = currencyModel
		currencyService.isSuccessful = true
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.success(response) = result else {
				fatalError()
			}
			XCTAssertEqual(response, expect)
		}
	}
}
