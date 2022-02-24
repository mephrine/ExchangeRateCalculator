//
//  CurrencyRepositoryImplTests.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation
import XCTest
@testable import ExchangeRateCalculator

class CurrencyRepositoryImplTests: XCTestCase {
	private var remoteDataSource: StubCurrencyRemoteDataSource!
	private var repository: CurrencyReposiroyImpl!
	private let currency = Currency(krw: 1192.9398794964, jpy: 115.0967667032, php: 51.3268409469)
	
	override func setUpWithError() throws {
		repository = CurrencyReposiroyImpl(remoteDataSource: remoteDataSource)
		let currencyModel = CurrencyModel(
			remittanceCountry: "USD",
			timestamp: "2022-02-23T00:00:00Z",
			recipientCoutries: [
				CurrencyModel.ChangedCurrencyModel(quoteCurrency: "KRW", mid: 1192.9398794964),
				CurrencyModel.ChangedCurrencyModel(quoteCurrency: "JPY", mid: 115.0967667032),
				CurrencyModel.ChangedCurrencyModel(quoteCurrency: "PHP", mid: 51.3268409469)
			]
		)
		remoteDataSource = StubCurrencyRemoteDataSource(currencyModel: currencyModel, error: ServerError.parse)
	}
	
	func test_shouldGetCurrencyModelWhenTheResultIsSuccessful() {
		remoteDataSource.isSuccessful = true
		
		let expect = currency
		repository.requestNewestCurrency { result in
			guard case let Result.success(response) = result else {
				fatalError()
			}
			
			XCTAssertEqual(response, expect)
		}
	}
}