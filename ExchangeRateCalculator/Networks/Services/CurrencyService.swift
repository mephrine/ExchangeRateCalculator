//
//  CurrencyService.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation

protocol CurrencyServiceType {
	func call(completionHandler: @escaping (Result<CurrencyModel, ServerError>) -> Void)
}

final class CurrencyService: CurrencyServiceType {
	func call(completionHandler: @escaping (Result<CurrencyModel, ServerError>) -> Void) {
		let urlString = Environment.baseURL + "/v1/convert_from.json"
		let parameters = [
			"from": "USD",
			"to": "KRW,JPY,PHP"
		]
		
		Networking.request(urlString: urlString, parameters: parameters, completionHandler: completionHandler)
	}
}
