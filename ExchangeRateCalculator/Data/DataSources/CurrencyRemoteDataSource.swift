//
//  CurrencyRemoteDataSource.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation

protocol CurrencyRemoteDataSource {
	func requestNewestCurrency(completionHandler: @escaping (Result<CurrencyModel, ServerError>) -> Void)
}

struct CurrencyRemoteDataSourceImpl: CurrencyRemoteDataSource {
	private let service: CurrencyServiceType
	
	init(service: CurrencyServiceType) {
		self.service = service
	}
	
	func requestNewestCurrency(completionHandler: @escaping (Result<CurrencyModel, ServerError>) -> Void) {
		do {
			try service.call { data, response, error in
				guard error == nil else {
					completionHandler(Result.failure(ServerError.unknowned))
					return
				}
				guard let unwrappedData = data else {
					completionHandler(Result.failure(ServerError.noData))
					return
				}
				guard let response = response as? HTTPURLResponse,
							(200 ..< 299) ~= response.statusCode
				else {
					completionHandler(Result.failure(ServerError.requestFailed))
					return
				}
				
				guard let parsedData = try? JSONDecoder().parse(from: unwrappedData, to: CurrencyModel.self) else {
					completionHandler(Result.failure(ServerError.parse))
					return
				}
				
				completionHandler(Result.success(parsedData))
			}
		} catch {
			guard let serverError = error as? ServerError else { return }
			completionHandler(Result.failure(serverError))
		}
	}
}
