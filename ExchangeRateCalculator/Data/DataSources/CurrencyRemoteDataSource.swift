//
//  CurrencyRemoteDataSource.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation

protocol CurrencyRemoteDataSource {
	func requestNewestCurrency(completionHandler: @escaping (Result<CurrencyModel, ServerError>) -> Void) throws
}

struct CurrencyRemoteDataSourceImpl: CurrencyRemoteDataSource {
	private let service: CurrencyServiceType
	
	init(service: CurrencyServiceType) {
		self.service = service
	}
	
	func requestNewestCurrency(completionHandler: @escaping (Result<CurrencyModel, ServerError>) -> Void) throws {
		service.call { response in
			completionHandler(response)
		}
	}
}
