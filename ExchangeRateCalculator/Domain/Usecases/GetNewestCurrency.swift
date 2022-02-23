//
//  GetNewestCurrency.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/23.
//

import Foundation

struct GetNewestCurrency: Usecase {	
	private let repository: CurrencyRepository
	
	init(repository: CurrencyRepository) {
		self.repository = repository
	}
	
	func excute(completionHandler: @escaping (Result<Currency, ServerError>) -> Void) {
		self.repository.requestNewestCurrency(completionHandler: completionHandler)
	}
}
