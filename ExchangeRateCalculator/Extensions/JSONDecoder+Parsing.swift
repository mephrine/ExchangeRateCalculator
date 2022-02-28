//
//  JSONDecoder+Parsing.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

extension JSONDecoder {
	func parse<T: Decodable>(from data: Data, to type: T.Type) throws -> T {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	}
}
