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
		let expect = currency
		
		viewModel.requestNewestCurrency()
		
		XCTAssertEqual(expect, viewModel.currency)
	}
}
