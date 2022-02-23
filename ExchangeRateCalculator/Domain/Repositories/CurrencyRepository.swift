//
//  CurrencyRepository.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/23.
//

import Foundation

protocol CurrencyRepository {
	func requestNewestCurrency(completionHandler: (Result<Currency, ServerError>) -> Void)
}
