//
//  CurrencyModel.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation

struct CurrencyModel: Decodable {
	let remittanceCountry: String
	let timestamp: String
	let recipientCoutries: [ChangedCurrencyModel]
	
	enum CodingKeys: String, CodingKey {
		case remittanceCountry = "from"
		case timestamp
		case recipientCoutries = "to"
	}
	
	struct ChangedCurrencyModel: Decodable {
		let quoteCurrency: String
		let mid: Double
		
		enum CodingKeys: String, CodingKey {
			case quoteCurrency  = "quotecurrency"
			case mid
		}
	}
}
