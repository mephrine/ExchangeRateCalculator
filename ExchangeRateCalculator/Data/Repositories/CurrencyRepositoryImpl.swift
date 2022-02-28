//
//  CurrencyRepositoryImpl.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation
import SystemConfiguration

struct CurrencyReposiroyImpl: CurrencyRepository {
	// MARK: - Inject
	private let remoteDataSource: CurrencyRemoteDataSource
	
	
	public init(remoteDataSource: CurrencyRemoteDataSource) {
		self.remoteDataSource = remoteDataSource
		
	}
	
	// MARK: - Implementation
	func requestNewestCurrency(completionHandler: @escaping (Result<Currency, ServerError>) -> Void) {
		remoteDataSource.requestNewestCurrency { result in
			switch result {
			case .success(let response):
				completionHandler(Result.success(response.convertToEntity()))
			case .failure(let error):
				completionHandler(Result.failure(error))
			}
		}
	}
}
