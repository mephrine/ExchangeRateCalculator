//
//  GetNewestCurrencyTests.swift
//  GetNewestCurrencyTests
//
//  Created by Mephrine on 2022/02/22.
//

import XCTest
@testable import ExchangeRateCalculator

class GetNewestCurrencyTests: XCTestCase {
	private let usecase: GetNewestCurrency
	private let stubRespository: CurrencyRepository
	
	init {
		sutbRepository = StubCurrencyRepository()
		usecase = GetNewestCurrency(stubRespository)
	}
	
	func test_shouldGetCurrencyWhenTheResultIsSuccessful() {
		stubRespository.isSuccessful = true
		
		let expect = Currency(krw: 1192.9398794964, jpy: 115.0967667032, php: 51.3268409469)
		guard case let Result.success(result) = usecase.excute() else {
			fatalError()
		}
		
		XCTAssertEqual(result, expect)
	}
}

enum TestError: Error {
	
}
