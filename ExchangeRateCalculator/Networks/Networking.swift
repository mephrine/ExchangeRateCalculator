//
//  Networking.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/28.
//

import Foundation

enum Networking {
	static let timeOutDuration: Double = 30
	
	static func request(
		urlString: String,
		parameters: [String: String]? = nil,
		completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void 
	) throws {
		guard let urlComponents = makeURLComponents(urlString: urlString, parameters: parameters),
					let request = makeURLRequest(urlComponents: urlComponents)
		else {
			throw ServerError.invalidURL
		}
		
		URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
	}
	
	private static func makeURLRequest(urlComponents: URLComponents?) -> URLRequest? {
		guard let components = urlComponents,
					let requestURL = components.url
		else { return nil }
	
		let authorization = Environment.authorization
		var request = URLRequest(url: requestURL, timeoutInterval: Networking.timeOutDuration)
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
