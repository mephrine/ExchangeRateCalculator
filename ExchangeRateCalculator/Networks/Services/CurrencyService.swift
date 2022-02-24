//
//  CurrencyService.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation

protocol CurrencyServiceType {
	func call(completionHandler: @escaping (Result<CurrencyModel, Error>) -> Void)
}

final class CurrencyService: CurrencyServiceType {
	func call(completionHandler: @escaping (Result<CurrencyModel, Error>) -> Void) {
		guard  let request = makeURLRequest() else {
			completionHandler(Result.failure(ServerError.invalidURL))
			return
		}
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard error == nil else {
				completionHandler(Result.failure(error!))
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
			
			let decoder = JSONDecoder()
			guard let parsedData = try? decoder.decode(CurrencyModel.self, from: unwrappedData) else {
				completionHandler(Result.failure(ServerError.parse))
				return
			}
			
			completionHandler(Result.success(parsedData))
		}
	}
	
	private func makeURLRequest() -> URLRequest? {
		guard let components = urlComponents,
					let requestURL = components.url?.absoluteURL
		else { return nil }
	
		let authorization = Environment.authorization
		var request = URLRequest(url: requestURL, timeoutInterval: 30)
		request.httpMethod  = "GET"
		request.allHTTPHeaderFields = [
			"Authorization": authorization
		]
		
		return request
	}
	
	private var urlComponents: URLComponents? {
		let urlString = Environment.baseURL + "/v1/convert_from.json"
		let parameters = [
			"from": "USD",
			"to": "KRW,JPY,PHP"
		]
		
		var componets = URLComponents(string: urlString)
		componets?.queryItems = parameters.map { key, value in
			URLQueryItem(name: key, value: value)
		}
		
		return componets
	}
}
