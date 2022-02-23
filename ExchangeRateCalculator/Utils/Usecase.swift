//
//  Usecase.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/23.
//

import Foundation

protocol Usecase {
	associatedtype Return
	
	func excute(completionHandler: @escaping (Result<Return, ServerError>) -> ())
}
