//
//  DateFormatter+Utils.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

extension DateFormatter {
	static let `default`: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .iso8601)
		dateFormatter.timeZone = TimeZone.current
		dateFormatter.locale = Locale(identifier: "ko_kr")
		return dateFormatter
	}()
}
