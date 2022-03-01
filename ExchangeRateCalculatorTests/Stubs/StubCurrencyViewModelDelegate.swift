//
//  StubCurrencyViewModelDelegate.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation
@testable import ExchangeRateCalculator

final class StubCurrencyViewModelDelegate: CurrencyViewModelDelegate {
	var currency: Currency?
	var remittance: Remittance?
	var error: Error?
	
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeCurrency currency: Currency) {
		self.currency = currency
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeRemittance remittance: Remittance) {
		self.remittance = remittance
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurServerError error: ServerError) {
		self.error = error
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurRemittanceValueError error: Remittance.ValueError) {
		self.error = error
	}
	
	
}
