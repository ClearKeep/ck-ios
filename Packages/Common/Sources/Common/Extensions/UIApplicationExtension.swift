//
//  UIApplicationExtension.swift
//  Common
//
//  Created by NamNH on 05/11/2021.
//

import UIKit

private enum Constants {
	static let statusBarTag = 1234
}
public extension UIApplication {
	func setStatusBarBackgroundColor(_ color: UIColor) {
		if #available(iOS 13.0, *) {
			let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
			
			if let statusBar = keyWindow?.viewWithTag(Constants.statusBarTag) {
				statusBar.backgroundColor = color
			} else {
				let statusBar = UIView(frame: keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
				statusBar.backgroundColor = color
				statusBar.tag = Constants.statusBarTag
				keyWindow?.addSubview(statusBar)
			}
		} else {
			let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
			statusBar?.backgroundColor = color
		}
	}
}
