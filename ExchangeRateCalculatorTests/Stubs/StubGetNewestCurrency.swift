//
//  StubGetNewestCurrency.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation
@testable import ExchangeRateCalculator
import XCTest

final class StubGetNewestCurrency: GetNewestCurrencyUsecase {
	var isSuccessful = true
	let currency: Currency
	let error: ServerError
	let expectation: XCTestExpectation?
	var callCount = 0
	
	init(currency: Currency, error: ServerError, expectation: XCTestExpectation? = nil) {
		self.currency = currency
		self.error = error
		self.expectation = expectation
	}
	
	func excute(completionHandler: @escaping (Result<Currency, ServerError>) -> Void) {
		isSuccessful ? completionHandler(Result.success(currency)) : completionHandler(Result.failure(error))
		callCount += 1
		expectation?.fulfill()
	}
}

