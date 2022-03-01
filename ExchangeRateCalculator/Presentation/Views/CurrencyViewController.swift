//
//  CurrencyViewController.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/22.
//

import UIKit

class CurrencyViewController: UIViewController {
	private enum UI {
		static let remittanceTextFieldMaxLength: Int = 5
	}
	
	// MARK: - Properties
	private let viewModel: CurrencyViewModel
	private let pickerItems = ReceiptCountry.allCases
	
	// MARK: - Views
	private var currencyView: CurrencyView {
		self.view as! CurrencyView
	}
	
	private lazy var countryPickerView: UIPickerView = {
		let pickerView = UIPickerView()
		self.view.addSubview(pickerView)
		pickerView.delegate = self
		pickerView.dataSource  = self
		return pickerView
	}()
	
	// MARK: - Initialize
	init(viewModel: CurrencyViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		viewModel.delegate = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	override func loadView() {
		self.view = CurrencyView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		viewModel.loadedView()
	}
}

fileprivate extension CurrencyViewController {
	func setupUI() {
		currencyView.remittanceTextField.delegate = self
		currencyView.remittanceTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
	}
}

// MARK: - Actions
extension  CurrencyViewController {
	@objc func didChangeTextField(textField: UITextField) {
		guard let changedText = textField.text else { return }
		viewModel.changedRemittanceTextField(to: changedText)
	}
}

// MARK: - CurrencyViewModelDelegate
extension CurrencyViewController: CurrencyViewModelDelegate {
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeCurrency currency: Currency, of country: ReceiptCountry) {
		currencyView.changeCurrency(by: currency, and: country)
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didChangeAmountReceived amountReceived: AmountReceived) {
		currencyView.changeAmountReceived(by: amountReceived)
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurServerError error: ServerError) {
		currencyView.showErrorMessage(of: error)
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurRemittanceValueError error: Remittance.ValueError) {
		currencyView.showErrorMessage(of: error)
	}
	
	func currencyViewModel(_ currencyViewModel: CurrencyViewModel, didOccurExchangeRateCalculatorValueError error: ExchangeRateCalculator.ValueError) {
		currencyView.showErrorMessage(of: error)
	}
}

// MARK: - UITextFieldDelegate
extension CurrencyViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldText = textField.text ?? ""
		guard let oldTextRange = Range(range, in: oldText) else { return false }
		
		let newText = oldText.replacingCharacters(in: oldTextRange, with: string)
		return newText.count <= UI.remittanceTextFieldMaxLength
	}
}

// MARK: - UIPickerViewDataSource
extension CurrencyViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerItems.count
	}
}


// MARK: - UIPickerViewDelegate
extension CurrencyViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		pickerItems[row].countryUnit
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		viewModel.selectedReceiptCountryPickerItem(pickerItems[row])
	}
}
