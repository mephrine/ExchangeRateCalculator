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
	
	private var stubDelegate = StubCurrencyViewModelDelegate()
	
	override func tearDownWithError() throws {
		stubDelegate = StubCurrencyViewModelDelegate()
	}
	
	func test_shouldGetDatawhenTheRequestIsSuccessfulForGetNewestCurrencyUsecase() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
	
		viewModel.requestNewestCurrency()
		
		let expectResult = currency
		waitForExpectations(timeout: 3, handler: nil)
		XCTAssertEqual(expectResult, viewModel.currency)
	}
	
	func test_shouldGetErrorWhenTheRequestForTheGetNewestCurrencyUsecaseFails() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect, isSuccessful: false))
		viewModel.delegate = stubDelegate
		
		viewModel.requestNewestCurrency()
		
		let expectResult = ServerError.unknowned
		waitForExpectations(timeout: 3, handler: nil)
		XCTAssertEqual(expectResult, stubDelegate.error as? ServerError)
	}
	
	func test_shouldBeCalledOnlyTheLastAPIWhenTheViewModelMakesMulipleRequests() {
		let expect = expectation(description: "requestNewestCurrency")
		let stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned, expectation: expect)
		stubUsecase.isSuccessful = true
		let viewModel = CurrencyViewModel(usecase: stubUsecase)
		viewModel.delegate = stubDelegate
		
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
		viewModel.delegate = stubDelegate
		
		(1...10000).forEach { number in
			viewModel.changedRemittanceTextField(to: String(number))
			XCTAssertEqual(stubDelegate.remittance?.amount, number)
		}
	}
	
	func test_shouldThrowOutOfRangeErrorWhenTheRemittanceAmountIsoutOfRangeFrom1To10000() {
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase())
		viewModel.delegate = stubDelegate
		
		viewModel.changedRemittanceTextField(to: String(-1))
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.outOfRange)
		
		
		viewModel.changedRemittanceTextField(to: String(10001))
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.outOfRange)
	}
	
	func test_shouldThrowIsNotNumericErrorWhenTheRemittanceAmountIsNotNumeric() {
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase())
		viewModel.delegate = stubDelegate
		
		viewModel.changedRemittanceTextField(to: "abcd")
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.isNotNumereic)
		
		viewModel.changedRemittanceTextField(to: "😀")
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.isNotNumereic)
		
		viewModel.changedRemittanceTextField(to: "가나다라마바사아")
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.isNotNumereic)
	}
}

fileprivate extension CurrencyViewModelTest {
	func makeStubUsecase(expectation: XCTestExpectation? = nil, isSuccessful: Bool = true) -> StubGetNewestCurrency {
		let stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned, expectation: expectation)
		stubUsecase.isSuccessful = isSuccessful
		return stubUsecase
	}
}
