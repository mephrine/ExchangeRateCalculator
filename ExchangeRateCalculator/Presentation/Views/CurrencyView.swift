//
//  CurrencyView.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import UIKit

final class CurrencyView: UIView {
	//MARK: - Constants
	private enum UI {
		static let titleLabelTopMargin: CGFloat = 40
		static let containerStackViewTopMargin: CGFloat = 20
		static let horiznotalMargin: CGFloat = 20
		static let containerStackViewVerticalSpacing: CGFloat = 10
		static let horizontalStackViewSpacing: CGFloat = 5
		static let resultLabelTopMargin: CGFloat = 50
		static let infoTitleLabelWidth: CGFloat = 55
		static let remittanceTextFieldWidth: CGFloat = 100
		static let remittanceTextFieldBorderWidth: CGFloat = 1
		static let animationDuration: CGFloat = 0.3
		
		enum Color {
			static let background: UIColor = .white
			static let font: UIColor = .black
			static let infoFont: UIColor = .darkGray
			static let errorFont: UIColor = .red
			static let hint: UIColor = .gray
			static let remittanceTextFieldBorder: UIColor = .gray
		}
		
		enum Font {
			static let title: UIFont = .boldSystemFont(ofSize: 30)
			static let info: UIFont = .systemFont(ofSize: 15)
			static let result: UIFont = .systemFont(ofSize: 21)
		}
	}
	
	//MARK: - Views
	private let titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UI.Font.title
		label.textColor = UI.Color.font
		label.numberOfLines = 1
		label.text = "환율 계산"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let resultLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UI.Font.result
		label.textColor = UI.Color.font
		label.numberOfLines = 0
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var remittanceCountryInfoLabel: UILabel = {
		let label = makeInfoLabel()
		return label
	}()
	
	lazy var receiptCountryInfoLabel: UILabel = {
		let label = makeInfoLabel()
		return label
	}()
	
	private lazy var currencyInfoLabel: UILabel = {
		let label = makeInfoLabel()
		return label
	}()
	
	private lazy var inquiryTimeInfoLabel: UILabel = {
		let label = makeInfoLabel()
		return label
	}()
	
	private lazy var remittanceAmountInfoLabel: UILabel = {
		let label = makeInfoLabel()
		return label
	}()
		
	private lazy var containerStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			makeHorizontalAxisStackView(arrangeSubViews: makeInfoTitleLabel(text: "송금국가"), makeDivider(), remittanceCountryInfoLabel),
			makeHorizontalAxisStackView(arrangeSubViews: makeInfoTitleLabel(text: "수취국가"), makeDivider(), receiptCountryInfoLabel),
			makeHorizontalAxisStackView(arrangeSubViews: makeInfoTitleLabel(text: "환율"), makeDivider(), currencyInfoLabel),
			makeHorizontalAxisStackView(arrangeSubViews: makeInfoTitleLabel(text: "조회시간"), makeDivider(), inquiryTimeInfoLabel),
			makeHorizontalAxisStackView(arrangeSubViews: makeInfoTitleLabel(text: "송금액"), makeDivider(), remittanceTextField, remittanceAmountInfoLabel)
		])
		stackView.axis = .vertical
		stackView.spacing = UI.containerStackViewVerticalSpacing
		stackView.alignment = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	let remittanceTextField: UITextField = {
		let textField = UITextField(frame: .zero)
		textField.attributedPlaceholder = NSAttributedString(
			string: "송금액 입력 ",
			attributes: [NSAttributedString.Key.foregroundColor : UI.Color.hint])
		textField.font = UI.Font.info
		textField.textColor = UI.Color.font
		textField.textAlignment = .right
		textField.layer.borderWidth = UI.remittanceTextFieldBorderWidth
		textField.layer.borderColor = UI.Color.remittanceTextFieldBorder.cgColor
		textField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textField.widthAnchor.constraint(equalToConstant: UI.remittanceTextFieldWidth)
		])
		return textField
	}()
	
	//MARK: - Initialize
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		initUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	private func setupUI() {
		self.backgroundColor = UI.Color.background
		
		addSubview(titleLabel)
		addSubview(containerStackView)
		addSubview(resultLabel)

		let titleLabelConstraints = [
			titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: UI.titleLabelTopMargin),
			titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		]

		let containerStackViewConstraints = [
			containerStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UI.containerStackViewTopMargin),
			containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UI.horiznotalMargin),
			containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UI.horiznotalMargin)
		]

		let resultLabelConstraints = [
			resultLabel.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: UI.resultLabelTopMargin),
			resultLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UI.horiznotalMargin),
			resultLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UI.horiznotalMargin),
			resultLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor)
		]
		
		NSLayoutConstraint.activate([
			titleLabelConstraints,
			containerStackViewConstraints,
			resultLabelConstraints
		].flatMap { $0 })
	}
	
	private func initUI() {
		resultLabel.text = "송금액을 입력해주세요."
		remittanceCountryInfoLabel.text = "미국 (USD)"
		receiptCountryInfoLabel.text = "한국 (KRW)"
		currencyInfoLabel.text = ""
		inquiryTimeInfoLabel.text = ""
		remittanceAmountInfoLabel.text = "USD"
	}
	
	private func makeInfoTitleLabel(text: String) -> UILabel {
		let label = UILabel()
		label.font = UI.Font.info
		label.textColor = UI.Color.infoFont
		label.numberOfLines = 1
		label.textAlignment = .right
		label.text = text
		label.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			label.widthAnchor.constraint(equalToConstant: UI.infoTitleLabelWidth)
		])
		return label
	}
	
	private func makeInfoLabel() -> UILabel {
		let label = UILabel()
		label.font = UI.Font.info
		label.textColor = UI.Color.infoFont
		label.numberOfLines = 0
		label.textAlignment = .left
		return label
	}
	
	private func makeHorizontalAxisStackView(arrangeSubViews: UIView...) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: arrangeSubViews)
		stackView.axis = .horizontal
		stackView.spacing = UI.horizontalStackViewSpacing
		stackView.distribution = .fill
		return stackView
	}
	
	private func makeDivider() -> UILabel {
		let label = UILabel()
		label.font = UI.Font.info
		label.textColor = UI.Color.font
		label.numberOfLines = 0
		label.text = ":"
		label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000) , for: .horizontal)
		return label
	}
}

// MARK: - Actions
extension CurrencyView {
	func changeCurrency(by currency: Currency, and receiptCountry: ReceiptCountry) {
		let currencyAmount = currency.find(by: receiptCountry)?.convertToCurrencyFormat() ?? "0"
		
		
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.receiptCountryInfoLabel.text = receiptCountry.countryUnit
			self.inquiryTimeInfoLabel.text = currency.inquiryTime
			self.currencyInfoLabel.text = "\(currencyAmount) \(receiptCountry.currencyUnit) / USD"
			
			self.receiptCountryInfoLabel.alpha = 0
			self.inquiryTimeInfoLabel.alpha = 0
			self.currencyInfoLabel.alpha = 0
			
			UIView.animate(withDuration: UI.animationDuration,
										 delay: 0,
										 options: []) {
				self.receiptCountryInfoLabel.alpha = 1
				self.inquiryTimeInfoLabel.alpha = 1
				self.currencyInfoLabel.alpha = 1
			}
			
		}
	}
	
	func changeAmountReceived(by amountReceived: AmountReceived) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.resultLabel.textColor = UI.Color.infoFont
			self.resultLabel.text = amountReceived.amount.isEmpty ? "송금액을 입력해주세요." : "수취금액은 \(amountReceived.amount) 입니다."
		}
	}
	
	func changeRemittanceAmountToBlank() {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.resultLabel.textColor = UI.Color.infoFont
			self.resultLabel.text = "송금액을 입력해주세요."
		}
	}
	
	func showErrorMessage(of error: Error) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			self.resultLabel.textColor = UI.Color.errorFont
			self.resultLabel.text = error.localizedDescription
		}
	}
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct DemoViewPreView: PreviewProvider {
	static var previews: some View {
		UIViewPreview {
			return CurrencyView()
		}.previewDevice(PreviewDevice.init(rawValue: "iPhone 12 Pro"))
	}
}
#endif
