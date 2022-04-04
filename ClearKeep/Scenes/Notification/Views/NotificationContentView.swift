//
//  NotificationView.swift
//  ClearKeep
//
//  Created by đông on 25/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

// MARK: - Constant
private enum Constant {
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightBackground = 60.0
	static let borderLineWidth = 2.0
	static let sizeCircle = 52.0
	static let paddingTitlePreview = 40.0
}

struct NotificationContentView: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IServerSettingModel]>
	@State private(set) var isShowUserProfile = false
	@State private(set) var isShowPreview = true
	@State private(set) var isShowDisturb = true

	// MARK: - Init
	init(samples: Loadable<[IServerSettingModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension NotificationContentView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension NotificationContentView {
	var notRequestedView: some View {
		VStack(spacing: Constant.spacer) {
			backgroundColorTop
				.frame(maxWidth: .infinity, maxHeight: Constant.heightBackground)
			VStack(spacing: Constant.spacer) {
				buttonTop
				title
				showPreview
				doNotDisturb
				Spacer()
			}
			.padding(.horizontal, Constant.paddingHorizontal)
		}
		.edgesIgnoringSafeArea(.all)
	}

	var buttonTop: some View {
		HStack {
			Button(action: {
			}, label: {
				AppTheme.shared.imageSet.crossIcon
					.renderingMode(.template)
					.foregroundColor(foregroundCrossButton)
			})
			Spacer()
		}
		.frame(maxWidth: .infinity)
	}

	var title: some View {
		Text("Notification.Title".localized)
			.frame(maxWidth: .infinity, alignment: .leading)
			.font(AppTheme.shared.fontSet.font(style: .body1))
	}

	var showPreview: some View {
		VStack {
			HStack {
				Text("Notification.Preview".localized)
					.font(AppTheme.shared.fontSet.font(style: .placeholder1))
					.foregroundColor(foregroundNotificationTitle)
				Toggle("", isOn: $isShowPreview)
					.toggleStyle(SwitchToggleStyle(tint: backgroundColorPrimary))
			}
			Text("Notification.Preview.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder3))
				.foregroundColor(foregroundShowPreviewTitle)
				.padding(.trailing, Constant.paddingTitlePreview)
		}
	}

	var doNotDisturb: some View {
		HStack {
			Text("Notification.Disturb".localized)
				.font(AppTheme.shared.fontSet.font(style: .placeholder1))
				.foregroundColor(foregroundNotificationTitle)
			Toggle("", isOn: $isShowDisturb)
				.toggleStyle(SwitchToggleStyle(tint: backgroundColorPrimary))
		}
	}
}

// MARK: - Color func
private extension NotificationContentView {
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorTop: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorGrey4: Color {
		AppTheme.shared.colorSet.grey4
	}

	var backgroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var backgroundToggle: Color {
		colorScheme == .light ? backgroundColorPrimary : backgroundColorGrey4
	}

	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorBlack: Color {
		AppTheme.shared.colorSet.black
	}

	var foregroundColorGrey3: Color {
		AppTheme.shared.colorSet.grey3
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundShowPreviewTitle: Color {
		colorScheme == .light ? foregroundColorGrey3 : foregroundColorPrimary
	}

	var foregroundNotificationTitle: Color {
		colorScheme == .light ? foregroundColorBlack : foregroundColorGrey3
	}

	var foregroundCrossButton: Color {
		colorScheme == .light ? foregroundColorBlack : foregroundColorWhite
	}
}

struct NotificationContentView_Previews: PreviewProvider {
	static var previews: some View {
		NotificationContentView()
	}
}
