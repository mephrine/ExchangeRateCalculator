//
//  ReceiptCountry.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

enum ReceiptCountry: CaseIterable {
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
	
	var countryUnit: String {
		switch self {
		case .korea: return "한국 (KRW)"
		case .japan: return "일본 (JPY)"
		case .philippines: return "필리핀 (PHP)"
		}
	}
}
