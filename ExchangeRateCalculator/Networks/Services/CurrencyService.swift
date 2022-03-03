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
		let urlString = "/live"
		let parameters = [
			"access_key": Environment.authorization
		]
		try Networking.request(urlString: urlString, parameters: parameters, completionHandler: completionHandler)
	}
}
