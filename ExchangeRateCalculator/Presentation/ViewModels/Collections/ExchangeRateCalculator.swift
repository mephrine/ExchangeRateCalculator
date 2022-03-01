//
//  ExchangeRateCalculator.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

enum ExchangeRateCalculator {
	enum ValueError: Error {
		case invalidKey
		case invalidFormat
	}
	
	static func calculate(with receiptCountry: ReceiptCountry, and currency: Currency, remittance: Remittance) throws -> AmountReceived {
		guard let currencyOfReceiptCountry = currency.find(by: receiptCountry) else {
			throw ValueError.invalidKey
		}
		
		let calculatedAmountReceived = currencyOfReceiptCountry * Double(remittance.amount)
		
		guard let amountReceived = AmountReceived(amountReceived: calculatedAmountReceived, currencyUnit: receiptCountry.currencyUnit) else {
			throw ValueError.invalidFormat
		}
		
		return amountReceived
	}
}
