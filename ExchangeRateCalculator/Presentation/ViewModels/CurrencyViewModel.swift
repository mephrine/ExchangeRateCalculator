//
//  CurrencyViewModel.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

final class CurrencyViewModel {
	private enum Options {
		static let requestIntervalTime = 300
	}
	
	// MARK: - Inject
	private let usecase: GetNewestCurrencyUsecase
	
	// MARK: - Properties
	var currency: Currency? = nil
	var error: ServerError? = nil
	var usecaseExcute: DispatchWorkItem?
	var remittance: Int = 0
	
	init(usecase: GetNewestCurrencyUsecase) {
		self.usecase = usecase
	}
	
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
			self.remittance = changedRemittance.amount
		} catch {
			
		}
	}
	
	private func makeUsecaseExcuteDispatchWorkItem() -> DispatchWorkItem {
		DispatchWorkItem { [weak self] in
			guard let self = self else { return }
			self.usecase.excute { result in
				switch result {
				case .success(let currency):
					self.currency = currency
				case .failure(let error):
					self.error = error
				}
			}
		}
	}
	
	private func removeViewAfter(duringTime: Double) {
		guard let clearExcute = self.usecaseExcute else { return }
		DispatchQueue.main.asyncAfter(deadline: .now() + duringTime, execute: clearExcute)
	}
}
