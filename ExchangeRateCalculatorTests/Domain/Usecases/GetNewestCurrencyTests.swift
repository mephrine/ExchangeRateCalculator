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
	private let currency = Currency(currencies: [
		"KRW" :  1192.9398794964,
		"JPY": 115.0967667032,
		"PHP": 51.3268409469
	], inquiryTime: "2018-12-27 12:34")
	
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
