//
//  AdvancedServerView.swift
//  ClearKeep
//
//  Created by MinhDev on 08/03/2022.
//

import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let radius = 40.0
	static let spacing = 20.0
	static let padding = 10.0
}

struct AdvancedServerView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var severUrl: String
	@State private(set) var severUrlStyle: TextInputStyle
	@State private(set) var showingNewPass: Bool = false
	init(severUrl: String = "",
		 severUrlStyle: TextInputStyle = .default) {
		self._severUrl = .init(initialValue: severUrl)
		self._severUrlStyle = .init(initialValue: severUrlStyle)
	}
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(backgroundViewColor)
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: btnBack)
	}
}
// MARK: - Private
private extension AdvancedServerView {

	var backgroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.primaryDefault
	}

	var backgroundViewColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.black
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.offWhite
	}
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}
// MARK: - Private Func
private extension AdvancedServerView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	var content: AnyView {
		AnyView(fogotPasswordView)
	}
}
// MARK: - Loading Content
private extension AdvancedServerView {
	var fogotPasswordView: some View {
		VStack(spacing: Constants.spacing) {
			Spacer()
			Text("AdvancedServer.Title".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundBackButton)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.all)
			CommonTextField(text: $severUrl,
							inputStyle: $severUrlStyle,
							inputIcon: AppTheme.shared.imageSet.mailIcon,
							placeHolder: "AdvancedServer.ServerUrl".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					severUrlStyle = .normal
				} else {
					severUrlStyle = .highlighted
				}
			})
			Button("AdvancedServer.Submit".localized) {
				self.showingNewPass = true
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.all, Constants.padding)
			.background(backgroundButton)
			.foregroundColor(foregroundButton)
			.cornerRadius(Constants.radius)
			Spacer()
			Spacer()
			Spacer()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding(.all, Constants.padding)
	}

	var btnBack : some View {
		Button(action: customBack) {
			HStack {
				AppTheme.shared.imageSet.backIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Spacer()
				Text("AdvancedServer.SeverSetting".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}
// MARK: - Interactor
private extension AdvancedServerView {
}
// MARK: - Preview
#if DEBUG
struct AdvancedServerView_Previews: PreviewProvider {
	static var previews: some View {
		AdvancedServerView(severUrl: "", severUrlStyle: (.normal))
	}
}
#endif
