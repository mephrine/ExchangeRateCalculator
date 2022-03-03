//
//  CurrencyModel.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation

struct CurrencyModel: Decodable {
	let timestamp: Date
	let quotes: ChangedCurrencyModel
	
	struct ChangedCurrencyModel: Decodable {
		let krw: Double
		let jpy: Double
		let php: Double
		
		enum CodingKeys: String, CodingKey {
			case krw  = "USDKRW"
			case jpy  = "USDJPY"
			case php  = "USDPHP"
		}
	}
}

// MARK: - Convert
extension CurrencyModel {
	func convertToEntity() -> Currency {
		let currencies: [String: Double] = [
			ReceiptCountry.korea.currencyUnit: self.quotes.krw,
			ReceiptCountry.japan.currencyUnit: self.quotes.jpy,
			ReceiptCountry.philippines.currencyUnit: self.quotes.php
		]
		
		return Currency(
			currencies: currencies,
			inquiryTime: timestamp.convertToString(of: "yyyy-MM-dd HH:mm")
		)
	}
}
