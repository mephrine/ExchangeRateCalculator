//
//  CurrencyViewModel.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import Foundation

final class CurrencyViewModel {
	// MARK: - Inject
	private let usecase: GetNewestCurrencyUsecase
	
	// MARK: - Properties
	var currency: Currency? = nil
	
	init(usecase: GetNewestCurrencyUsecase) {
		self.usecase = usecase
	}
	
	func requestNewestCurrency() {
		usecase.excute { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let currency):
				self.currency = currency
			case .failure:
				break
			}
		}
	}
}
