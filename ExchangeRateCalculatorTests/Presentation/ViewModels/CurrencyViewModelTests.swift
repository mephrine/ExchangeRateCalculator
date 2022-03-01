//
//  CurrencyViewModelTests.swift
//  ExchangeRateCalculatorTests
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation
import XCTest
@testable import ExchangeRateCalculator

final class CurrencyViewModelTest: XCTestCase {
	private let currency = Currency(currencies: [
		"KRW" :  1192.9398794964,
		"JPY": 115.0967667032,
		"PHP": 51.3268409469
	])
	
	override func setUpWithError() throws {
		
	}
	
	func test_shouldGetDatawhenTheRequestIsSuccessfulForGetNewestCurrencyUsecase() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
	
		viewModel.requestNewestCurrency()
		
		let expectResult = currency
		waitForExpectations(timeout: 3, handler: nil)
		XCTAssertEqual(expectResult, viewModel.currency)
	}
	
	func test_shouldGetErrorWhenTheRequestForTheGetNewestCurrencyUsecaseFails() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect, isSuccessful: false))
		
		viewModel.requestNewestCurrency()
		
		let expectResult = ServerError.unknowned
		waitForExpectations(timeout: 3, handler: nil)
		XCTAssertEqual(expectResult, viewModel.error)
	}
	
	func test_shouldBeCalledOnlyTheLastAPIWhenTheViewModelMakesMulipleRequests() {
		let expect = expectation(description: "requestNewestCurrency")
		let stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned, expectation: expect)
		stubUsecase.isSuccessful = true
		let viewModel = CurrencyViewModel(usecase: stubUsecase)
		
		viewModel.requestNewestCurrency()
		viewModel.requestNewestCurrency()
		viewModel.requestNewestCurrency()
		viewModel.requestNewestCurrency()
		
		let expectResult = currency
		let verify = 1
		waitForExpectations(timeout: 3, handler: nil)
		XCTAssertEqual(expectResult, viewModel.currency)
		XCTAssertEqual(stubUsecase.callCount, verify)
	}
	
	func test_shoudGetResultWhenTheRemittanceAmountIsIncludedBetween1And10000() {
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase())
		
		(1...10000).forEach { number in
			viewModel.changedRemittanceTextField(to: String(number))
			XCTAssertEqual(viewModel.remittance, number)
		}
	}
}

fileprivate extension CurrencyViewModelTest {
	func makeStubUsecase(expectation: XCTestExpectation? = nil, isSuccessful: Bool = true) -> StubGetNewestCurrency {
		let stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned, expectation: expectation)
		stubUsecase.isSuccessful = isSuccessful
		return stubUsecase
	}
}
