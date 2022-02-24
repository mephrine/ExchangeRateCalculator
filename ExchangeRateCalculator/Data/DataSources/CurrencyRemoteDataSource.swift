//
//  CurrencyRemoteDataSource.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation

protocol CurrencyRemoteDataSource {
	func requestNewestCurrency(completionHandler: (Result<CurrencyModel, ServerError>) -> Void)
}

struct CurrenctRemoteDataSourceImpl: CurrencyRemoteDataSource {
	func requestNewestCurrency(completionHandler: (Result<CurrencyModel, ServerError>) -> Void) {
		
	}
}
