//
//  CurrencyModelFixture.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/24.
//

import Foundation

enum CurrencyModelFixture {
	static let data: Data =
 """
{
		"terms": "http://www.xe.com/legal/dfs.php",
		"privacy": "http://www.xe.com/privacy.php",
		"from": "USD",
		"amount": 1.0,
		"timestamp": "2022-02-23T00:00:00Z",
		"to": [
				{
						"quotecurrency": "KRW",
						"mid": 1192.9398794964
				},
				{
						"quotecurrency": "JPY",
						"mid": 115.0967667032
				},
				{
						"quotecurrency": "PHP",
						"mid": 51.3268409469
				}
		]
}
""".data(using: .utf8)!
}
