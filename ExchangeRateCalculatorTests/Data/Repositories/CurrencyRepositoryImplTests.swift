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
	], inquiryTime: "2018-12-27 12:34")
	
	override func setUpWithError() throws {
		
	}
	
	func test_shouldGetCurrencyModelWhenTheResultIsSuccessful() {
		let repository = CurrencyRepositoryImpl(remoteDataSource: makeStubDataSource(error: ServerError.unknowned))
		
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
		let repository = CurrencyRepositoryImpl(remoteDataSource: makeStubDataSource(error: error, isSuccessful: false))
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
			timestamp: Date(timeIntervalSince1970: 1545881647),
		 quotes: CurrencyModel.ChangedCurrencyModel(krw: 1192.9398794964, jpy: 115.0967667032, php: 51.3268409469))
		let remoteDataSource = StubCurrencyRemoteDataSource(currencyModel: currencyModel, error: error)
		remoteDataSource.isSuccessful = isSuccessful
		
		return remoteDataSource
	}
}
