//
//  AdvancedSeverView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 16.0
	static let paddingTopButton = 38.0
}

struct AdvancedSeverView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Binding var customServer: CustomServer
	@State private(set) var editingCustomServer: CustomServer
	@State private(set) var severUrlStyle: TextInputStyle = .default
	@State private(set) var isLogin: Bool = false
	
	// MARK: - Init
	init(customServer: Binding<CustomServer>) {
		self._customServer = customServer
		self._editingCustomServer = State(initialValue: customServer.wrappedValue)
	}
	
	// MARK: - Body
	var body: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			CheckBoxButtons(text: "AdvancedServer.SeverButton".localized, isChecked: $editingCustomServer.isSelectedCustomServer, action: { editingCustomServer.customServerURL = "" })
				.foregroundColor(titleColor)
			if editingCustomServer.isSelectedCustomServer {
				Text("AdvancedServer.Title".localized)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(titleColor)
					.frame(maxWidth: .infinity, alignment: .leading)
				CommonTextField(text: $editingCustomServer.customServerURL,
								inputStyle: $severUrlStyle,
								placeHolder: "AdvancedServer.ServerUrl".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					severUrlStyle = isEditing ? .highlighted : .normal
				})
				RoundedButton("AdvancedServer.Submit".localized,
							  disabled: .constant(editingCustomServer.customServerURL.isEmpty),
							  action: submitAction)
				.padding(.top, Constants.paddingTopButton)
			}
			Spacer()
		}
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.padding()
		.applyNavigationBarPlainStyle(title: "AdvancedServer.SeverSetting".localized,
									  titleColor: titleColor,
									  backgroundColors: colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary : AppTheme.shared.colorSet.gradientBlack,
									  leftBarItems: {
			BackButton(backAction)
		},
									  rightBarItems: {
			Spacer()
		})
		.grandientBackground()
		.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension AdvancedSeverView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private func
private extension AdvancedSeverView {
	func backAction() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func submitAction() {
		customServer = editingCustomServer
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct AdvancedSeverView_Previews: PreviewProvider {
	static var previews: some View {
		AdvancedSeverView(customServer: .constant(CustomServer()))
	}
}
#endif
