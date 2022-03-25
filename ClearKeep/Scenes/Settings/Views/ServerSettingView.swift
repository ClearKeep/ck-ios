//
//  ServerSettingView.swift
//  ClearKeep
//
//  Created by đông on 24/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightBackground = 60.0
}

struct ServerSettingView: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

//	@Binding var isShowing: Bool
	@State private(set) var samples: Loadable<[IServerSettingModel]>
	@State private(set) var serverName: String
	@State private(set) var serverUrl: String
	@State private(set) var serverStyle: TextInputStyle = .default
	@State private(set) var serverUrlStyle: TextInputStyle = .default
	@State private(set) var isShowUserProfile = false

	// MARK: - Init
	init(samples: Loadable<[IServerSettingModel]> = .notRequested,
		 serverName: String = "",
		 inputStyle: TextInputStyle = .default,
		 serverUrl: String = "") {
//		self._isShowing = isShowing
		self._samples = .init(initialValue: samples)
		self._serverName = .init(initialValue: serverName)
		self._serverStyle = .init(initialValue: inputStyle)
		self._serverUrl = .init(initialValue: serverUrl)
		self._serverUrlStyle = .init(initialValue: inputStyle)
	}

	// MARK: Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension ServerSettingView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension ServerSettingView {
	var notRequestedView: some View {
		VStack(spacing: Constant.spacer) {
			backgroundColorTop
				.frame(maxWidth: .infinity, maxHeight: Constant.heightBackground)
			VStack(spacing: Constant.spacer) {
				buttonTop
				title
				serverNameInput
				serverUrlInput
				Spacer()
			}
			.padding(.horizontal, Constant.paddingHorizontal)
		}
		.edgesIgnoringSafeArea(.all)
	}

	var buttonTop: some View {
		HStack {
			Button(action: {
//				isShowing = false
			}, label: {
				AppTheme.shared.imageSet.crossIcon
			})
			Spacer()
		}
		.frame(maxWidth: .infinity)
	}

	var title: some View {
		Text("Server.Title".localized)
			.frame(maxWidth: .infinity, alignment: .leading)
			.font(AppTheme.shared.fontSet.font(style: .body1))
	}

	var serverNameInput: some View {
		VStack(alignment: .leading) {
			Text("Server.Name".localized)
			CommonTextField(text: $serverName,
							inputStyle: $serverStyle,
							placeHolder: "Server.Placeholder".localized,
							onEditingChanged: { isEditting in
				if isEditting {
					serverStyle = .normal
				} else {
					serverStyle = .highlighted
				}
			})
		}
	}

	var serverUrlInput: some View {
		VStack(alignment: .leading) {
			Text("Server.Url".localized)
			HStack {
				CommonTextField(text: $serverUrl,
								inputStyle: $serverUrlStyle,
								placeHolder: "Server.Placeholder".localized,
								onEditingChanged: { isEditting in
					if isEditting {
						serverStyle = .normal
					} else {
						serverStyle = .highlighted
					}
				})
				ZStack {
					Circle()
						.strokeBorder(AppTheme.shared.colorSet.primaryDefault, lineWidth: 2)
						.background(Circle().foregroundColor(AppTheme.shared.colorSet.offWhite))
						.frame(width: 52, height: 52)
					Button(action: {
		//				isShowing = false
					}, label: {
						AppTheme.shared.imageSet.linkIcon
					})
				}
			}
		}
	}
}

// MARK: - Color func
private extension ServerSettingView {
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorTop: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}
}

struct ServerSettingView_Previews: PreviewProvider {
	static var previews: some View {
		ServerSettingView()
    }
}
