//
//  Networking.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/28.
//

import Foundation

enum Networking {
	static func request<T: Decodable>(
		urlString: String,
		parameters: [String: String]? = nil,
		completionHandler: @escaping (Result<T, ServerError>) -> Void
	) {
		guard let urlComponents = makeURLComponents(urlString: urlString, parameters: parameters),
					let request = makeURLRequest(urlComponents: urlComponents)
		else {
			completionHandler(Result.failure(ServerError.invalidURL))
			return
		}
		
		URLSession.shared.dataTask(with: request) { data, response, error in
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
			
			guard let parsedData = try? JSONDecoder().parse(from: unwrappedData, to: T.self) else {
				completionHandler(Result.failure(ServerError.parse))
				return
			}
			
			completionHandler(Result.success(parsedData))
		}
	}
	
	private static func makeURLRequest(urlComponents: URLComponents?) -> URLRequest? {
		guard let components = urlComponents,
					let requestURL = components.url
		else { return nil }
	
		let authorization = Environment.authorization
		var request = URLRequest(url: requestURL, timeoutInterval: 30)
		request.httpMethod  = "GET"
		request.allHTTPHeaderFields = [
			"Authorization": authorization
		]
		
		return request
	}
	
	private static func makeURLComponents(urlString: String, parameters: [String: String]?) -> URLComponents? {
		let fullURLString = Environment.baseURL + urlString
		var componets = URLComponents(string: fullURLString)
		
		if let queryParameters = parameters {
			componets?.queryItems = queryParameters.map { key, value in
				URLQueryItem(name: key, value: value)
			}
		}
		
		return componets
	}
}
