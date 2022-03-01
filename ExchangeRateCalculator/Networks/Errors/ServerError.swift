//
//  ServerError.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/23.
//

import Foundation

enum ServerError: Error, CaseIterable {
	case parse
	case noData
	case requestFailed
	case invalidURL
	case unknowned
}

extension ServerError: LocalizedError {
	var errorDescription: String? {
		"서버 통신 중에 에러가 발생했습니다."
	}
}
