//
//  Double+Utils.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/02.
//

import Foundation

extension Double {
	func convertToCurrencyFormat() -> String? {
		let numberFormat = NumberFormatter()
		numberFormat.roundingMode = .floor
		numberFormat.numberStyle = .decimal
		numberFormat.maximumFractionDigits = 2
		return numberFormat.string(for: self)
	}
}
