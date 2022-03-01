//
//  CurrencyViewController.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/22.
//

import UIKit

class CurrencyViewController: UIViewController {
	// MARK: - Properties
	private let viewModel: CurrencyViewModel
	
	// MARK: - Views
	private var currencyView: CurrencyView {
		self.view as! CurrencyView
	}
	
	// MARK: - Initialize
	init(viewModel: CurrencyViewModel) {
		self.viewModel = viewModel
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	override func loadView() {
		self.view = CurrencyView()
		setupUI()
		initUI()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

fileprivate extension CurrencyViewController {
	func setupUI() {
		currencyView.remittanceTextField.delegate = self
	}
	
	func initUI() {
		
	}
}

extension CurrencyViewController: UITextFieldDelegate {
	
}
