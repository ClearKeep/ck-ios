//
//  BottomSheet.swift
//  CommonUI
//
//  Created by Quang Pham on 29/04/2022.
//

import SwiftUI

public struct BottomSheet {

	/// Wraps the UIKit's detents (UISheetPresentationController.Detent)
	public enum Detents {

		/// Creates a system detent for a sheet that's approximately half the height of the screen, and is inactive in compact height.
		case medium
		/// Creates a system detent for a sheet at full height.
		case large
		/// Allows both medium and large detents. Opens in medium first
		case mediumAndLarge
		/// Allows both large and medium detents. Opens in large first
		case largeAndMedium
		
		case custom(CGFloat)

		var value: [UISheetPresentationController.Detent] {
			switch self {
			case .medium:
				return [.medium()]

			case .large:
				return [.large()]

			case .mediumAndLarge, .largeAndMedium:
				return [.medium(), .large()]
			case .custom(let height):
				return [._detent(withIdentifier: "custom", constant: height)]
			}
		}
	}

	/// Wraps the UIKit's largestUndimmedDetentIdentifier.
	/// *"The largest detent that doesn’t dim the view underneath the sheet."*
	public enum LargestUndimmedDetent: CaseIterable, Identifiable {
		case medium
		case large

		fileprivate var value: UISheetPresentationController.Detent.Identifier {
			switch self {
			case .medium:
				return .medium

			case .large:
				return .large
			}
		}

		public var description: String {
			switch self {
			case .medium:
				return "Medium"

			case .large:
				return "Large"
			}
		}

		public var id: Int {
			self.hashValue
		}
	}

	private static var ref: UINavigationController?

	public static func dismiss() {
		ref?.dismiss(animated: true, completion: { ref = nil })
	}

	/// Handles the presentation logic of the new UIKit's pageSheet modal presentation style.
	///
	/// *Sarun's* blog article source: https://sarunw.com/posts/bottom-sheet-in-ios-15-with-uisheetpresentationcontroller/
	static func present<ContentView: View>(detents: Detents, shouldScrollExpandSheet: Bool, largestUndimmedDetent: LargestUndimmedDetent?, showGrabber: Bool, cornerRadius: CGFloat?, @ViewBuilder _ contentView: @escaping () -> ContentView) {
		let detailViewController = UIHostingController(rootView: contentView())
		let nav = UINavigationController(rootViewController: detailViewController)

		ref = nav

		nav.modalPresentationStyle = .pageSheet
		
		if let sheet = nav.sheetPresentationController {
			sheet.detents = detents.value
			sheet.prefersScrollingExpandsWhenScrolledToEdge = shouldScrollExpandSheet
			sheet.largestUndimmedDetentIdentifier = largestUndimmedDetent?.value ?? .none
			sheet.prefersGrabberVisible = showGrabber
			sheet.preferredCornerRadius = cornerRadius
			
			// Missing artice's section "Switch between available detents" section
			// Missing property sheet.prefersEdgeAttachedInCompactHeight
			switch detents {
			case .largeAndMedium:
				sheet.selectedDetentIdentifier = .large

			case .mediumAndLarge:
				sheet.selectedDetentIdentifier = .medium

			default: break
			}
		}

		UIApplication.shared.windows.first?.rootViewController?.present(nav, animated: true, completion: nil)
	}
}
