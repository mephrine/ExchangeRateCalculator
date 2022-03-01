//
//  ReceiptCountry.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

enum ReceiptCountry {
	case korea
	case japan
	case philippines
	
	var currencyUnit: String {
		switch self {
		case .korea: return "KRW"
		case .japan: return "JPY"
		case .philippines: return "PHP"
		}
	}
}
