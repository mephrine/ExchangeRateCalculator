//
//  StubCurrencyService.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation
@testable import ExchangeRateCalculator

final class StubCurrencyService: CurrencyServiceType {
	var isSuccessful: Bool = true
	private let currencyModel: CurrencyModel
	private let error: ServerError
	
	init(currencyModel: CurrencyModel, error: ServerError) {
		self.currencyModel = currencyModel
		self.error = error
	}
	
	func call(completionHandler: @escaping (Result<CurrencyModel, ServerError>) -> Void) {
		isSuccessful ? completionHandler(Result.success(currencyModel)) : completionHandler(Result.failure(error))
	}
}
