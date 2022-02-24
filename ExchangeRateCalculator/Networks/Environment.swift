//
//  Environment.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation

public enum Environment {
	// MARK: - Keys
	enum Keys {
		static let baseURL = "BaseURL"
		static let authorization = "Authorization"
	}

	// MARK: - Plist
	private static let infoDictionary: [String: Any] = {
		guard let info = Bundle.main.infoDictionary else {
			fatalError("NetworkService.plist file not found")
		}
		return info
	}()

	// MARK: - Values
	public static let baseURL: String = {
		guard let urlString = Environment.infoDictionary[Keys.baseURL] as? String else {
			fatalError("BaseURL not set in plist for this environment")
		}
		return urlString
	}()

	public static let authorization: String = {
		guard let authorization = Environment.infoDictionary[Keys.authorization] as? String else {
			fatalError("Authorization not set in plist for this environment")
		}
		return authorization
	}()
}
