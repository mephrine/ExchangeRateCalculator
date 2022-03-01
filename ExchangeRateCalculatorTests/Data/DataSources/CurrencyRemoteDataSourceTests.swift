//
//  CurrencyRemoteDataSourceTests.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/02/25.
//

import Foundation
import XCTest
@testable import ExchangeRateCalculator

class CurrencyRemoteDataSourceTests: XCTestCase {
	private let currencyModel = CurrencyModel(
		remittanceCountry: "USD",
		timestamp: "2022-02-23T00:00:00Z".convertToDate(of: "yyyy-MM-dd'T'HH:mm:ssZ")!,
		recipientCoutries: [
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "KRW", mid: 1192.9398794964),
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "JPY", mid: 115.0967667032),
			CurrencyModel.ChangedCurrencyModel(quoteCurrency: "PHP", mid: 51.3268409469)
		])
	private let fixtureData = CurrencyModelFixture.data
	
	override func setUpWithError() throws {
		
	}
	
	func test_shouldReturnCurrencyModelWhenTheResponseIsSuccessful() {
		let dataSource = CurrencyRemoteDataSourceImpl(service: makeStubService(data: fixtureData))
		
		let expect = currencyModel
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.success(response) = result else {
				fatalError()
			}
			XCTAssertEqual(response, expect)
		}
	}
	
	func test_shouldGetUnknownErrorWhenTheErrorIsNotNil() {
		let dataSource = CurrencyRemoteDataSourceImpl(service: makeStubService(error: ServerError.invalidURL, isSuccessful: false))
		let expect = ServerError.unknowned
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.failure(response) = result else {
				fatalError()
			}
			XCTAssertEqual(response, expect)
		}
	}
	
	func test_shouldGetNoDataErrorWhenTheDataIsNil() {
		let dataSource = CurrencyRemoteDataSourceImpl(service: makeStubService())
		
		let expect = ServerError.noData
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.failure(response) = result else {
				fatalError()
			}

			XCTAssertEqual(response, expect)
		}
	}
	
	func test_shouldGetRequestFailedErrorWhenTheStatusCodeIsOutOfRange200To299() {
		let dataSource = CurrencyRemoteDataSourceImpl(service: makeStubService(statusCode: 199, data: fixtureData))
		
		let expect = ServerError.requestFailed
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.failure(response) = result else {
				fatalError()
			}

			XCTAssertEqual(response, expect)
		}
	}
	
	func test_shouldGetParseErrorWhenTheDataIsNotCurrencyModelData() {
		let testData = "test".data(using: .utf8)
		let dataSource = CurrencyRemoteDataSourceImpl(service: makeStubService(data: testData))
		
		let expect = ServerError.parse
		
		dataSource.requestNewestCurrency { result in
			guard case let Result.failure(response) = result else {
				fatalError()
			}

			XCTAssertEqual(response, expect)
		}
	}
}


// MARK: - Stubs
fileprivate extension CurrencyRemoteDataSourceTests {
	func makeStubService(statusCode: Int = 200, data: Data? = nil, error: Error? = nil, isSuccessful: Bool = true) -> StubCurrencyService {
		let response = HTTPURLResponse(url: URL(string: Environment.baseURL)!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
		let currencyService = StubCurrencyService(data: data, urlResponse: response, error: error)
		currencyService.isSuccessful = isSuccessful
		
		return currencyService
	}
}
