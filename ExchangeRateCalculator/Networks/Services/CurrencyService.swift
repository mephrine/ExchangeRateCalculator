//
//  CurrencyService.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation

protocol CurrencyServiceType {
	func call(completionHandler: @escaping (CurrencyModel?) -> Void)
}

final class CurrencyService: CurrencyServiceType {
	func call(completionHandler: @escaping (CurrencyModel?) -> Void) {
		
	}
}
