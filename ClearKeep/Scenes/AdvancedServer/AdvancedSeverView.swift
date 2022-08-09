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
	@State private(set) var editingCustomServer: CustomServer = CustomServer()
	@State private(set) var severUrlStyle: TextInputStyle = .default
	@State private(set) var isLogin: Bool = false
	@State private var messageAlert: String = ""
	@State private var isShowAlert: Bool = false
	@State private(set) var loadable: Loadable<Bool> = .notRequested
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.grandientBackground()
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private variable
private extension AdvancedSeverView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.grey3
	}
}

// MARK: - Private
private extension AdvancedSeverView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded:
			return AnyView(loadedView)
		case .failed(let error):
			return AnyView(errorView(AdvancedServerErrorView(error)))
		}
	}
}

// MARK: - Loading Content
private extension AdvancedSeverView {
	var notRequestedView: some View {
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
		.padding(.horizontal, Constants.spacing)
		.applyNavigationBarPlainStyle(title: "AdvancedServer.SeverSetting".localized,
									  titleColor: titleColor,
									  backgroundColors: colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary : AppTheme.shared.colorSet.gradientBlack,
									  leftBarItems: {
			BackButton(backAction)
		},
									  rightBarItems: {
			Spacer()
		})
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	var loadedView: some View {
		return AnyView(LoginView(customServer: editingCustomServer, rootIsActive: .constant(false)))
	}
	
	func errorView(_ error: AdvancedServerErrorView) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
	}
}

// MARK: - Private func
private extension AdvancedSeverView {
	func backAction() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func submitAction() {
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.advancedSeverInteractor.workspaceInfo(workspaceDomain: editingCustomServer.customServerURL)
		}
	}
}

// MARK: - Preview
#if DEBUG
struct AdvancedSeverView_Previews: PreviewProvider {
	static var previews: some View {
		AdvancedSeverView()
	}
}
#endif
