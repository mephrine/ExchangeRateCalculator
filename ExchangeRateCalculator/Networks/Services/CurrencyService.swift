//
//  CurrencyService.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation

protocol CurrencyServiceType {
	func call(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws
}

final class CurrencyService: CurrencyServiceType {
	func call(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
		let urlString = "/v1/convert_from.json"
		let parameters = [
			"from": "USD",
			"to": "KRW,JPY,PHP"
		]
		try Networking.request(urlString: urlString, parameters: parameters, completionHandler: completionHandler)
	}
}
