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
	private let currency = Currency(currencies: [
		"KRW" :  1192.9398794964,
		"JPY": 115.0967667032,
		"PHP": 51.3268409469
	], inquiryTime: "2022-02-23 09:00")
	
	override func setUpWithError() throws {
		
	}
	
	func test_shouldGetCurrencyModelWhenTheResultIsSuccessful() {
		let repository = CurrencyReposiroyImpl(remoteDataSource: makeStubDataSource(error: ServerError.unknowned))
		
		let expect = currency
		repository.requestNewestCurrency { result in
			guard case let Result.success(response) = result else {
				fatalError()
			}
			
			XCTAssertEqual(response, expect)
		}
	}
	
	func test_shouldGetErrorWhenTheResultIsFailure() {
		ServerError.allCases.forEach { error in
			verify(error: error)
		}
	}
	
	private func verify(error: ServerError) {
		let repository = CurrencyReposiroyImpl(remoteDataSource: makeStubDataSource(error: error, isSuccessful: false))
		let expect = error
		repository.requestNewestCurrency { result in
			guard case let Result.failure(response) = result else {
				fatalError()
			}
			
			XCTAssertEqual(response, expect)
		}
	}
}

fileprivate extension CurrencyRepositoryImplTests {
	func makeStubDataSource(error: ServerError, isSuccessful: Bool = true) -> StubCurrencyRemoteDataSource {
		let currencyModel = CurrencyModel(
			remittanceCountry: "USD",
			timestamp: "2022-02-23T00:00:00Z".convertToDate(of: "yyyy-MM-dd'T'HH:mm:ssZ")!,
			recipientCoutries: [
				CurrencyModel.ChangedCurrencyModel(quoteCurrency: "KRW", mid: 1192.9398794964),
				CurrencyModel.ChangedCurrencyModel(quoteCurrency: "JPY", mid: 115.0967667032),
				CurrencyModel.ChangedCurrencyModel(quoteCurrency: "PHP", mid: 51.3268409469)
			]
		)
		let remoteDataSource = StubCurrencyRemoteDataSource(currencyModel: currencyModel, error: error)
		remoteDataSource.isSuccessful = isSuccessful
		
		return remoteDataSource
	}
}
