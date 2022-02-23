//
//  GetNewestCurrencyTests.swift
//  GetNewestCurrencyTests
//
//  Created by Mephrine on 2022/02/22.
//

import XCTest
@testable import ExchangeRateCalculator

class GetNewestCurrencyTests: XCTestCase {
	private var usecase: GetNewestCurrency!
	private var stubRespository: StubCurrencyRepository!
	private let currency = Currency(krw: 1192.9398794964, jpy: 115.0967667032, php: 51.3268409469)
	
	override func setUpWithError() throws {
		stubRespository = StubCurrencyRepository(currency: currency, error: ServerError.parse)
		usecase = GetNewestCurrency(repository: stubRespository)
	}
	
	func test_shouldGetCurrencyWhenTheResultIsSuccessful() {
		stubRespository.isSuccessful = true
		
		let expect = currency
		usecase.excute { response in
			guard case let Result.success(result) = response else {
				fatalError()
			}
			
			XCTAssertEqual(result, expect)
		}
	}
	
	func test_shouldGetServerErrorWhenTheResultIsFailure() {
		stubRespository.isSuccessful = false
		
		usecase.excute { response in
			guard case let Result.failure(error) = response else {
				fatalError()
			}
			
			XCTAssert(error is ServerError)
		}
	}
}
