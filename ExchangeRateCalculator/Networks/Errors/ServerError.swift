//
//  ServerError.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/23.
//

import Foundation

enum ServerError: Error {
	case network
	case `internal`
	case parse
	case noData
	case requestFailed
	case invalidURL
	case unknowned
}
