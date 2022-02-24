//
//  StubCurrencyRemoteDataSource.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation
@testable import ExchangeRateCalculator

final class StubCurrencyRemoteDataSource: CurrencyRemoteDataSource {
	var isSuccessful: Bool = true
	let currencyModel: CurrencyModel
	let error: ServerError
	
	init(currencyModel: CurrencyModel, error: ServerError) {
		self.currencyModel = currencyModel
		self.error = error
	}
	
	func requestNewestCurrency(completionHandler: (Result<CurrencyModel, ServerError>) -> Void) {
		isSuccessful ? completionHandler(Result.success(currencyModel)) : completionHandler(Result.failure(error))
	}
}
