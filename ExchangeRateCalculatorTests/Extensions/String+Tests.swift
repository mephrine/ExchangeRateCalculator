//
//  String+Tests.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

extension String {
	func convertToDate(of format: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.date(from: self)
	}
}
