//
//  StubCurrencyService.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation
@testable import ExchangeRateCalculator

final class StubCurrencyService: CurrencyServiceType {
	private let currencyModel: CurrencyModel?
	init(currencyModel: CurrencyModel?) {
		self.currencyModel = currencyModel
	}
	
	func call(completionHandler: @escaping (CurrencyModel?) -> Void) {
		completionHandler(currencyModel)
	}
}
