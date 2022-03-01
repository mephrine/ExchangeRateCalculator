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
	var viewModel: CurrencyViewModel!
	var stubUsecase: StubGetNewestCurrency!
	private let currency = Currency(currencies: [
		"KRW" :  1192.9398794964,
		"JPY": 115.0967667032,
		"PHP": 51.3268409469
	])
	
	override func setUpWithError() throws {
		stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned)
		viewModel = CurrencyViewModel(usecase: stubUsecase)
	}
	
	func test_shouldGetDatawhenTheRequestIsSuccessfulForGetNewestCurrencyUsecase() {
		stubUsecase.isSuccessful = true
	
		viewModel.requestNewestCurrency()
		
		let expect = currency
		XCTAssertEqual(expect, viewModel.currency)
	}
	
	func test_shouldGetErrorWhenTheRequestForTheGetNewestCurrencyUsecaseFails() {
		stubUsecase.isSuccessful = false
		
		viewModel.requestNewestCurrency()
		
		let expect = ServerError.unknowned
		XCTAssertEqual(expect, viewModel.error)
	}
	
	func test_shouldBeCalledOnlyTheLastAPIWhenTheViewModelMakesMulipleRequests() {
		let expect = expectation(description: "requestNewestCurrency")
		let stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned, expectation: expect)
		let viewModel = CurrencyViewModel(usecase: stubUsecase)
		stubUsecase.isSuccessful = true
		
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
}
