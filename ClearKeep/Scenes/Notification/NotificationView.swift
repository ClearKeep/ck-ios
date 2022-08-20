//
//  NotificationView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightBackground = 60.0
	static let borderLineWidth = 2.0
	static let sizeCircle = 52.0
	static let paddingTitlePreview = 40.0
}

struct NotificationView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IServerSettingModel]> = .notRequested
	@AppStorage("preview") private var isShowPreview = true
	@AppStorage("disturb") private var isShowDisturb = true

	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.spacer) {
			backgroundColorTop
				.frame(maxWidth: .infinity, maxHeight: Constants.heightBackground)
			VStack(spacing: Constants.spacer) {
				HStack {
					Button(action: backAction, label: {
						AppTheme.shared.imageSet.crossIcon
							.foregroundColor(foregroundCrossButton)
					})
					Spacer()
				}
				.frame(maxWidth: .infinity)

				Text("Notification.Title".localized)
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .body1))

				VStack(alignment: .leading) {
					ToggleCustom(text: "Notification.Preview".localized, isChecked: $isShowPreview)
						.onChange(of: isShowPreview) { _ in
							changeStatusPreview()
						}
					Text("Notification.Preview.Title".localized)
						.font(AppTheme.shared.fontSet.font(style: .placeholder3))
						.foregroundColor(foregroundShowPreviewTitle)
						.padding(.trailing, Constants.paddingTitlePreview)
				}
				ToggleCustom(text: "Notification.Disturb".localized, isChecked: $isShowDisturb).onChange(of: isShowDisturb) { _ in
					changeStatusDistub()
				}
				Spacer()
			}
			.padding(.horizontal, Constants.paddingHorizontal)
		}
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
	}
}

// MARK: - Interactor
private extension NotificationView {

	func backAction() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func unregisterForRemoteNotifications() {
		UIApplication.shared.unregisterForRemoteNotifications()
	}

	func registerForRemoteNotifications() {
		UIApplication.shared.registerForRemoteNotifications()
	}

	func changeStatusDistub() {
		isShowDisturb ? registerForRemoteNotifications() : unregisterForRemoteNotifications()
	}

	func changeStatusPreview() {
		isShowPreview.toggle()
	}
}

// MARK: - Colors
private extension NotificationView {
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorTop: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundToggle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.grey4
	}
	
	var foregroundShowPreviewTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundNotificationTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.grey3
	}

	var foregroundCrossButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}
}

// MARK: - Preview
#if DEBUG
struct NotificationView_Previews: PreviewProvider {
	static var previews: some View {
		NotificationView()
	}
}
#endif
