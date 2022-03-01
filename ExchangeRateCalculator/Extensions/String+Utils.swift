//
//  String+Utils.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

extension String {
	func convertToDefaultDateFormatter() -> DateFormatter {
		let dateFormatter = DateFormatter.default
		dateFormatter.dateFormat = self
		return dateFormatter
	}
}
