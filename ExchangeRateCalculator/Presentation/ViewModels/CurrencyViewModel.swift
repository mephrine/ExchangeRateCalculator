//
//  CurrencyViewModel.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation
import UIKit

protocol CurrencyViewModelDelegate: AnyObject {
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeCurrency currency: Currency)
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeAmountReceived amountReceived: AmountReceived)
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurServerError error: ServerError)
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurRemittanceValueError error: Remittance.ValueError)
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurExchangeRateCalculatorValueError error: ExchangeRateCalculator.ValueError)
}

protocol CurrencyViewAction {
	func loadedView()
	func changedRemittanceTextField(to remittance: String)
}

final class CurrencyViewModel {
	private enum Options {
		static let requestIntervalTime = 300
	}
	
	// MARK: - Inject
	private let usecase: GetNewestCurrencyUsecase
	
	// MARK: - Delegate
	weak var delegate: CurrencyViewModelDelegate?
	
	// MARK: - Properties
	private var usecaseExcute: DispatchWorkItem?
	private var currency: Currency? = nil
	private var receiptCounty: ReceiptCountry = .korea
	
	init(usecase: GetNewestCurrencyUsecase) {
		self.usecase = usecase
	}
	
	private func requestNewestCurrency() {
		if usecaseExcute?.isCancelled == false {
			usecaseExcute?.cancel()
		}
		let dispatchWorkItem = makeUsecaseExcuteDispatchWorkItem()
		self.usecaseExcute = dispatchWorkItem
		DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + .milliseconds(Options.requestIntervalTime), execute: dispatchWorkItem)
	}
}

// MARK: - Actions
extension CurrencyViewModel: CurrencyViewAction {
	func loadedView() {
		requestNewestCurrency()
	}
	
	func changedRemittanceTextField(to remittance: String) {
		do {
			guard let currentCurrency = currency else { return }
			let changedRemittance = try Remittance(remittance: remittance)
			let amountReceived = try ExchangeRateCalculator.calculate(with: receiptCounty, and: currentCurrency, remittance: changedRemittance)
			self.delegate?.currencyViewModel(self, didChangeAmountReceived: amountReceived)
		} catch {
			sendErrorToDeleagte(error)
		}
	}
	
	private func sendErrorToDeleagte(_ error: Error) {
		if let valueError = error as? Remittance.ValueError {
			delegate?.currencyViewModel(self, didOccurRemittanceValueError: valueError)
			return
		}
		
		if let valueError = error as? ExchangeRateCalculator.ValueError {
			delegate?.currencyViewModel(self, didOccurExchangeRateCalculatorValueError: valueError)
		}
	}
}

// MARK: - Utils {
fileprivate extension CurrencyViewModel {
	 func makeUsecaseExcuteDispatchWorkItem() -> DispatchWorkItem {
		DispatchWorkItem { [weak self] in
			guard let self = self else { return }
			self.usecase.excute { result in
				switch result {
				case .success(let currency):
					self.delegate?.currencyViewModel(self, didChangeCurrency: currency)
					self.currency = currency
				case .failure(let error):
					self.delegate?.currencyViewModel(self, didOccurServerError: error)
				}
			}
		}
	}
	
	func removeViewAfter(duringTime: Double) {
		guard let clearExcute = self.usecaseExcute else { return }
		DispatchQueue.main.asyncAfter(deadline: .now() + duringTime, execute: clearExcute)
	}
}
