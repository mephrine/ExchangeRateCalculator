//
//  StubGetNewestCurrency.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation
@testable import ExchangeRateCalculator

final class StubGetNewestCurrency: GetNewestCurrencyUsecase {
	var isSuccessful = true
	let currency: Currency
	let error: ServerError
	
	init(currency: Currency, error: ServerError) {
		self.currency = currency
		self.error = error
	}
	
	func excute(completionHandler: @escaping (Result<Currency, ServerError>) -> Void) {
		isSuccessful ? completionHandler(Result.success(currency)) : completionHandler(Result.failure(error))
	}
}

