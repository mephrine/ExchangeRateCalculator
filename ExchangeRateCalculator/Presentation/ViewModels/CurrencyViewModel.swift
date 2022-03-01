//
//  CurrencyViewModel.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

protocol CurrencyViewModelDelegate: AnyObject {
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeCurrency currency: Currency)
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeRemittance remittance: Remittance)
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurServerError error: ServerError)
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurRemittanceValueError error: Remittance.ValueError)
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
	var currency: Currency? = nil
	var usecaseExcute: DispatchWorkItem?
	
	init(usecase: GetNewestCurrencyUsecase) {
		self.usecase = usecase
	}	
}

// MARK: - Actions
extension CurrencyViewModel {
	func requestNewestCurrency() {
		if usecaseExcute?.isCancelled == false {
			usecaseExcute?.cancel()
		}
		let dispatchWorkItem = makeUsecaseExcuteDispatchWorkItem()
		self.usecaseExcute = dispatchWorkItem
		DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + .milliseconds(Options.requestIntervalTime), execute: dispatchWorkItem)
	}
	
	func changedRemittanceTextField(to remittance: String) {
		do {
			let changedRemittance = try Remittance(remittance: remittance)
			self.delegate?.currencyViewModel(self, didChangeRemittance: changedRemittance)
		} catch {
			guard let valueError = error as? Remittance.ValueError else { return }
			delegate?.currencyViewModel(self, didOccurRemittanceValueError: valueError)
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
