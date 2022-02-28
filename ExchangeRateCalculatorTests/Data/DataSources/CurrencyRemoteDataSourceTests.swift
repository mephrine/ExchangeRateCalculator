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
		
	}
	
	func test_shouldReturnCurrencyModelWhenTheResponseIsSuccessful() {
		let response = HTTPURLResponse(url: URL(string: Environment.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		let currencyService = StubCurrencyService(data: fixtureData, urlResponse: response, error: ServerError.invalidURL)
		currencyService.isSuccessful = true
		dataSource = CurrencyRemoteDataSourceImpl(service: currencyService)
		
		let expect = currencyModel
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.success(response) = result else {
				fatalError()
			}
			XCTAssertEqual(response, expect)
		}
	}
	
	func test_shouldGetUnknownErrorWhenTheErrorIsNotNil() {
		let response = HTTPURLResponse(url: URL(string: Environment.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		let currencyService = StubCurrencyService(data: fixtureData, urlResponse: response, error: ServerError.invalidURL)
		currencyService.isSuccessful = false
		dataSource = CurrencyRemoteDataSourceImpl(service: currencyService)
		
		let expect = ServerError.unknowned
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.failure(response) = result else {
				fatalError()
			}
			XCTAssertEqual(response, expect)
		}
	}
	
	func test_shouldGetNoDataErrorWhenTheDataIsNil() {
		let response = HTTPURLResponse(url: URL(string: Environment.baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		let currencyService = StubCurrencyService(data: nil, urlResponse: response, error: ServerError.invalidURL)
		currencyService.isSuccessful = true
		dataSource = CurrencyRemoteDataSourceImpl(service: currencyService)
		
		let expect = ServerError.noData
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.failure(response) = result else {
				fatalError()
			}

			XCTAssertEqual(response, expect)
		}
	}
}
