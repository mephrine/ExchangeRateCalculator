//
//  Date+Utils.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

extension Date {
	func convertToString(of format: String) -> String {
		let dateFormatter = format.convertToDefaultDateFormatter()
		return dateFormatter.string(from: self)
	}
}
