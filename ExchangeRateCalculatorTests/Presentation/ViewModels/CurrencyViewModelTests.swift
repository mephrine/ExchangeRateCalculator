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
	], inquiryTime: "2022-02-23 09:00")
	
	private var stubDelegate = StubCurrencyViewModelDelegate()
	
	override func tearDownWithError() throws {
		stubDelegate = StubCurrencyViewModelDelegate()
	}
	
	func test_shouldGetDataWhenTheRequestIsSuccessfulForGetNewestCurrencyUsecase() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
	
		viewModel.loadedView()
		
		let expectResult = currency
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertEqual(expectResult, stubDelegate.currency)
	}
	
	func test_shouldGetErrorWhenTheRequestForTheGetNewestCurrencyUsecaseFails() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect, isSuccessful: false))
		viewModel.delegate = stubDelegate
		
		viewModel.loadedView()
		
		let expectResult = ServerError.unknowned
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertEqual(expectResult, stubDelegate.error as? ServerError)
	}
	
	func test_shouldBeCalledOnlyTheLastAPIWhenTheViewModelMakesMulipleRequests() {
		let expect = expectation(description: "requestNewestCurrency")
		let stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned, expectation: expect)
		stubUsecase.isSuccessful = true
		let viewModel = CurrencyViewModel(usecase: stubUsecase)
		viewModel.delegate = stubDelegate
		
		viewModel.loadedView()
		viewModel.loadedView()
		viewModel.loadedView()
		viewModel.loadedView()
		
		let expectResult = currency
		let verify = 1
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertEqual(expectResult, stubDelegate.currency)
		XCTAssertEqual(stubUsecase.callCount, verify)
	}
	
	func test_shoudGetResultWhenTheRemittanceAmountIsIncludedBetween1And10000() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
		viewModel.loadedView()
		
		waitForExpectations(timeout: 5, handler: nil)
		
		[1, 11, 329, 499, 9999, 10000].forEach { number in
			viewModel.changedRemittanceTextField(to: String(number))
			XCTAssertNotNil(stubDelegate.amountReceived)
		}
	}
	
	func test_shouldThrowOutOfRangeErrorWhenTheRemittanceAmountIsoutOfRangeFrom1To10000() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
		viewModel.loadedView()
		
		waitForExpectations(timeout: 5, handler: nil)
		
		viewModel.changedRemittanceTextField(to: String(-1))
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.outOfRange)
		
		
		viewModel.changedRemittanceTextField(to: String(10001))
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.outOfRange)
	}
	
	func test_shouldThrowIsNotNumericErrorWhenTheRemittanceAmountIsNotNumeric() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
		viewModel.loadedView()
		
		waitForExpectations(timeout: 5, handler: nil)
		
		viewModel.changedRemittanceTextField(to: "abcd")
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.isNotNumereic)
		
		viewModel.changedRemittanceTextField(to: "😀")
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.isNotNumereic)
		
		viewModel.changedRemittanceTextField(to: "가나다라마바사아")
		XCTAssertEqual(stubDelegate.error! as! Remittance.ValueError, Remittance.ValueError.isNotNumereic)
	}
	
	func test_shouldGetTheAmountReceivedWhenTheRemittanceChanges() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
		viewModel.loadedView()
		
		waitForExpectations(timeout: 5, handler: nil)
		
		viewModel.changedRemittanceTextField(to: "1")
		XCTAssertEqual(stubDelegate.amountReceived?.amount, "1,192.93 KRW")
	}
	
	func test_shouldGetInquiryTimeWhenTheRequestIsSuccessfulForGetNewestCurrencyUsecase() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
		viewModel.loadedView()
		
		waitForExpectations(timeout: 5, handler: nil)
		
		XCTAssertEqual(stubDelegate.currency?.inquiryTime, "2022-02-23 09:00")
	}
	
	func test_shouldChangeCurrencyAndCountryWhenTheSelectedReceiptCountryPickerItemMethodOfTheViewModelIsCalled() {
		let expect = expectation(description: "requestNewestCurrency")
		let viewModel = CurrencyViewModel(usecase: makeStubUsecase(expectation: expect))
		viewModel.delegate = stubDelegate
	
		viewModel.selectedReceiptCountryPickerItem(ReceiptCountry.korea, remittanceAmount: nil)
		
		let expectResult = (currency: currency, country: ReceiptCountry.korea)
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertEqual(expectResult.currency, stubDelegate.currency)
		XCTAssertEqual(expectResult.country, stubDelegate.country)
	}
}

fileprivate extension CurrencyViewModelTest {
	func makeStubUsecase(expectation: XCTestExpectation? = nil, isSuccessful: Bool = true) -> StubGetNewestCurrency {
		let stubUsecase = StubGetNewestCurrency(currency: currency, error: ServerError.unknowned, expectation: expectation)
		stubUsecase.isSuccessful = isSuccessful
		return stubUsecase
	}
}
