//
//  SettingServerView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

// MARK: - Constant
private enum Constants {
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightBackground = 60.0
	static let borderLineWidth = 2.0
	static let sizeCircle = 52.0
}

struct SettingServerView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	
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
		self._samples = .init(initialValue: samples)
		self._serverName = .init(initialValue: serverName)
		self._serverStyle = .init(initialValue: inputStyle)
		self._serverUrl = .init(initialValue: serverUrl)
		self._serverUrlStyle = .init(initialValue: inputStyle)
	}
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		VStack(spacing: Constants.spacer) {
			backgroundColorTop
				.frame(maxWidth: .infinity, maxHeight: Constants.heightBackground)
			VStack(spacing: Constants.spacer) {
				HStack {
					Button(action: {
						self.presentationMode.wrappedValue.dismiss()
					}, label: {
						AppTheme.shared.imageSet.crossIcon
							.foregroundColor(foregroundCrossButton)
					})
					Spacer()
				}
				.frame(maxWidth: .infinity)
				
				Text("Server.Title".localized)
					.frame(maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .body1))
				
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
								.strokeBorder(AppTheme.shared.colorSet.primaryDefault, lineWidth: Constants.borderLineWidth)
								.background(Circle().foregroundColor(foregroundCircle))
								.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
							Button(action: {
							}, label: {
								AppTheme.shared.imageSet.linkIcon
									.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
							})
						}
					}
				}
				Spacer()
			}
			.padding(.horizontal, Constants.paddingHorizontal)
		}
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Loading Content
private extension SettingServerView {}

// MARK: - Interactor
private extension SettingServerView {
}

// MARK: - Colors
private extension SettingServerView {
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.darkGrey2, AppTheme.shared.colorSet.darkGrey2]), startPoint: .leading, endPoint: .trailing)
	}
	
	var foregroundCircle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.black
	}
	
	var foregroundCrossButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}
	
	var backgroundColorTop: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}
}

// MARK: - Preview
#if DEBUG
struct SettingServerView_Previews: PreviewProvider {
	static var previews: some View {
		SettingServerView()
	}
}
#endif
