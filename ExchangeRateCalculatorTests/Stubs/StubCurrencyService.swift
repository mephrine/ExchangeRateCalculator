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
	private let data: Data
	private let urlResponse: URLResponse
	private let error: Error
	
	init(data: Data, urlResponse: URLResponse, error: Error) {
		self.data = data
		self.urlResponse = urlResponse
		self.error = error
	}
	
	func call(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
		isSuccessful ? completionHandler(data, urlResponse, nil) : completionHandler(nil, nil, error)
	}
}
