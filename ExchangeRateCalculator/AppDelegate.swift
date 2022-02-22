//
//  AppDelegate.swift
//  ExchangeRateCalculator
//
//  Created by Mephrine on 2022/02/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	// MARK: - Properties
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		setupRootViewController()
		return true
	}
	
	private func setupRootViewController() {
		let rootViewController = ViewController()
		self.window?.rootViewController = rootViewController
		self.window?.makeKeyAndVisible()
	}
}

