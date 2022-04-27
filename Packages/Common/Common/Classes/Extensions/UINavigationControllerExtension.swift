//
//  UINavigationControllerExtension.swift
//  Common
//
//  Created by Quang Pham on 27/04/2022.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}

	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}

	// To make it works also with ScrollView
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		true
	}
}
