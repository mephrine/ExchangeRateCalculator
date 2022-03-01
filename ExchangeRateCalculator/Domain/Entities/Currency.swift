//
//  Currency.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/23.
//

import Foundation

struct Currency: Equatable {
	let currencies: [String: Double]
	let inquiryTime: String
}

fileprivate extension Currency {
	var krw: Double? {
		currencies["KRW"]
	}
	
	var jpy: Double? {
		currencies["JPY"]
	}
	
	var php: Double? {
		currencies["PHP"]
	}
}

extension Currency {
	func find(by receiptCountry: ReceiptCountry) -> Double? {
		currencies[receiptCountry.currencyUnit]
	}
}
