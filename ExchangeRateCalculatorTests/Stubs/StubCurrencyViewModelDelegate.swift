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
	var country: ReceiptCountry?
	var error: Error?
	var amountReceived: AmountReceived?
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeCurrency currency: Currency, of country: ReceiptCountry) {
		self.currency = currency
		self.country = country
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurServerError error: ServerError) {
		self.error = error
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurRemittanceValueError error: Remittance.ValueError) {
		self.error = error
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeAmountReceived amountReceived: AmountReceived) {
		self.amountReceived = amountReceived
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurExchangeRateCalculatorValueError error: ExchangeRateCalculator.ValueError) {
		self.error = error
	}
	
}
