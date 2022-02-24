//
//  EnvironmentTests.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation
import XCTest
import ExchangeRateCalculator

class EnvironmentTests: XCTestCase {
	func test_verifyBaseURLExistsInPlist() {
		XCTAssert(Environment.baseURL is URL)
	}
	
	func test_verifyAuthorizationExistsInPlist() {
		XCTAssert(Environment.authorization is String)
	}
}
