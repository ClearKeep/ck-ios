//
//  RegisterView.swift
//  ClearKeep
//
//  Created by MinhDev on 04/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let widthReView = UIScreen.main.bounds.width - 20
	static let spacer = 50.0
	static let heightLogo = 120.0
	static let widthLogo = 160.0
	static let spacing = 20.0
}

struct RegisterView: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var samples: Loadable<[IRegisterModel]>
	@State private(set) var username: String
	@State private(set) var displayname: String
	@State private(set) var password: String
	@State private(set) var rePassword: String
	@State private(set) var inputStyle: TextInputStyle = .default
	let inspection = ViewInspector<Self>()

	init(samples: Loadable<[IRegisterModel]> = .notRequested,
		 username: String = "",
		 displayname: String = "",
		 password: String = "",
		 rePassword: String = "",
		 inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._username = .init(initialValue: username)
		self._displayname = .init(initialValue: displayname)
		self._password = .init(initialValue: password)
		self._rePassword = .init(initialValue: rePassword)
		self._inputStyle = .init(initialValue: inputStyle)
	}
	// MARK: - Body
	var body: some View {
		NavigationView {
			self.content
		}
		.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
	}
}
// MARK: - Private variable
private extension RegisterView {
	var imageLogo: Image {
		AppTheme.shared.imageSet.logo
	}

	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}
	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .leading, endPoint: .trailing)
	}
	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}
// MARK: - Private
private extension RegisterView {
	var content: AnyView {
		switch samples {
		case .notRequested: return AnyView(notRequestedView)
		case let .isLoading(last, _): return AnyView(loadingView(last))
		case let .loaded(countries): return AnyView(loadedView(countries, showLoading: false))
		case let .failed(error): return AnyView(failedView(error))
		}
	}
}
// MARK: - Loading Content
private extension RegisterView {
	var notRequestedView: some View {
		Text("").onAppear(perform: reloadSamples)
	}

	func loadingView(_ previouslyLoaded: [IRegisterModel]?) -> some View {
		if let samples = previouslyLoaded {
			return AnyView(loadedView(samples, showLoading: true))
		} else {
			return AnyView(ActivityIndicatorView().padding())
		}
	}

	func failedView(_ error: Error) -> some View {
		ErrorView(error: error, retryAction: {
			self.reloadSamples()
		})
	}
}
// MARK: - Displaying Content
private extension RegisterView {
	func loadedView(_ samples: [IRegisterModel], showLoading: Bool) -> some View {
		ZStack {
			ScrollView {
				Spacer(minLength: Constants.spacer)
				VStack(spacing: Constants.spacing) {
					imageLogo
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.widthLogo, height: Constants.heightLogo)
					RegisterContentView(username: $username, password: $password, displayname: $displayname, rePassword: $rePassword, inputStyle: $inputStyle)
						.frame(width: Constants.widthReView)
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
	}
}

// MARK: - Interactors
private extension RegisterView {
	func reloadSamples() { }
}

// MARK: - Preview
struct RegisterView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterView()
	}
}
