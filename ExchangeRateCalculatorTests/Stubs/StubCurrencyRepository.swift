//
//  StubCurrencyRepository.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation
@testable import ExchangeRateCalculator

final class StubCurrencyRepository: CurrencyRepository {
	var isSuccessful: Bool = true
	let currency: Currency
	let error: ServerError
	
	init(currency: Currency, error: ServerError) {
		self.currency = currency
		self.error = error
	}
	
	func requestNewestCurrency(completionHandler: (Result<Currency, ServerError>) -> Void) {
		isSuccessful ? completionHandler(Result.success(currency)) : completionHandler(Result.failure(error))
	}
}
