//
//  AmountReceived.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

struct AmountReceived {
	let amount: String
	
	init?(amountReceived: Double, currencyUnit: String) {
		guard let amount = amountReceived.convertToCurrencyFormat() else {
			return nil
		}
		self.amount = "\(amount) \(currencyUnit)"
	}
}
