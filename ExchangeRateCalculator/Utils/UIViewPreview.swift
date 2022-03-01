//
//  UIViewPreview.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/03/01.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
		let view: View

		public init(_ builder: @escaping () -> View) {
				view = builder()
		}

		public func makeUIView(context: Context) -> UIView {
				view
		}

		public func updateUIView(_ view: UIView, context: Context) {
				view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
				view.setContentHuggingPriority(.defaultHigh, for: .vertical)
		}
}
#endif
