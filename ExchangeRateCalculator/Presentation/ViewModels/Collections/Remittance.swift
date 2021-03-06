//
//  Remittance.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

struct Remittance {
	enum ValueError: Error, LocalizedError {
		case isNotNumereic
		case outOfRange
		
		var errorDescription: String? {
			"송금액이 바르지 않습니다"
		}
	}
	
	let amount: Int
	
	init(remittance: String) throws {
		guard let amount = Int(remittance) else {
			throw ValueError.isNotNumereic
		}
		
		guard (1...10000).contains(amount) else {
			throw ValueError.outOfRange
		}
		
		self.amount = amount
	}
}
