//
//  SettingServerView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Common

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
	@State private(set) var isShowUserProfile = false
	@State private(set) var isShowPreview = true
	@State private(set) var isShowDisturb = true

	// MARK: - Init
	init(samples: Loadable<[IServerSettingModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		var contentView: some View {
			VStack(spacing: Constant.spacer) {
				backgroundColorTop
					.frame(maxWidth: .infinity, maxHeight: Constants.heightBackground)
				VStack(spacing: Constant.spacer) {
					buttonTop
					title
					serverNameInput
					serverUrlInput
					Spacer()
				}
				.padding(.horizontal, Constants.paddingHorizontal)
			}
			.edgesIgnoringSafeArea(.all)
		}

		var buttonTop: some View {
			HStack {
				Button(action: {
				}, label: {
					AppTheme.shared.imageSet.crossIcon
						.foregroundColor(foregroundCrossButton)
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
							.strokeBorder(AppTheme.shared.colorSet.primaryDefault, lineWidth: Constants.borderLineWidth)
							.background(Circle().foregroundColor(foregroundCircle))
							.frame(width: Constants.sizeCircle, height: Constant.sizeCircle)
						Button(action: {
						}, label: {
							AppTheme.shared.imageSet.linkIcon
								.foregroundColor(foregroundButtonLink)
						})
					}
				}
			}
		}
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
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

	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorBlack: Color {
		AppTheme.shared.colorSet.black
	}

	var foregroundCircle: Color {
		colorScheme == .light ? foregroundColorWhite : foregroundColorBlack
	}

	var foregroundCrossButton: Color {
		colorScheme == .light ? foregroundColorBlack : foregroundColorWhite
	}

	var backgroundColorTop: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var foregroundButtonLink: Color {
		AppTheme.shared.colorSet.primaryDefault
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
