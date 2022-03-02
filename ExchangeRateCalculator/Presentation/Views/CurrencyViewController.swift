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
		static let animationDuration: CGFloat = 0.3
		static let countryToolBarHeight: CGFloat = 45
	}
	
	// MARK: - Properties
	private let viewModel: CurrencyViewModel
	private let pickerItems = ReceiptCountry.allCases
	
	// MARK: - Views
	private let currencyView = CurrencyView()
	
	private var countryPickerView: UIPickerView? = nil
	private var countryToolBar: UIToolbar? = nil
	private var selectedCountryIndex: Int = 0
	
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
		self.view = currencyView
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
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapReceiptCountryInfoLabel))
		currencyView.receiptCountryInfoLabel.addGestureRecognizer(tapGestureRecognizer)
		currencyView.receiptCountryInfoLabel.isUserInteractionEnabled = true
	}
}

// MARK: - Actions
extension  CurrencyViewController {
	@objc func didChangeTextField(textField: UITextField) {
		guard let changedText = textField.text,
					changedText.isEmpty == false
		else {
			currencyView.changeRemittanceAmountToBlank()
			return
		}
		viewModel.changedRemittanceTextField(to: changedText)
	}
	
	@objc func didTapReceiptCountryInfoLabel() {
		showPickerView()
	}
	
	private func showPickerView() {
		makePickerView()
		showPickerViewWithFadeInAnimation()
	}
	
	@objc func didTapDoneButton() {
		hidePickerViewWithFadeOutAnimation()
		viewModel.selectedReceiptCountryPickerItem(pickerItems[selectedCountryIndex], remittanceAmount: currencyView.remittanceTextField.text)
	}
	
	private func makePickerView() {
		countryPickerView = UIPickerView()
		countryPickerView?.delegate = self
		countryPickerView?.dataSource  = self
		self.view.addSubview(countryPickerView!)
		
		countryPickerView?.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			countryPickerView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			countryPickerView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			countryPickerView!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
		])
		
		countryPickerView?.selectRow(selectedCountryIndex, inComponent: 0, animated: true)
		
		countryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UI.countryToolBarHeight))
		countryToolBar?.setItems([
			UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
		], animated: true)
		self.view.addSubview(countryToolBar!)
		
		countryToolBar?.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			countryToolBar!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			countryToolBar!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			countryToolBar!.bottomAnchor.constraint(equalTo: self.countryPickerView!.topAnchor)
		])
	}
	
	private func showPickerViewWithFadeInAnimation() {
		countryPickerView?.alpha = 0
		countryToolBar?.alpha = 0
		UIView.animate(withDuration: UI.animationDuration,
									 delay: 0,
									 options: []) {
			self.countryPickerView?.alpha = 1
			self.countryToolBar?.alpha = 1
		} completion: { completed in
		}
	}
	
	private func hidePickerViewWithFadeOutAnimation() {
		countryPickerView?.alpha = 1
		countryToolBar?.alpha = 1
		UIView.animate(withDuration: UI.animationDuration,
									 delay: 0,
									 options: []) {
			self.countryPickerView?.alpha = 0
			self.countryToolBar?.alpha = 0
		} completion: { completed in
			self.countryPickerView?.removeFromSuperview()
			self.countryToolBar?.removeFromSuperview()
		}
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
		selectedCountryIndex = row
	}
}
