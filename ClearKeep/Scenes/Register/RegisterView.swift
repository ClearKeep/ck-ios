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
import Networking

private enum Constants {
	static let logoSize = CGSize(width: 160.0, height: 120)
	static let logoPadding = UIEdgeInsets(top: 60.0, left: 0.0, bottom: 40.0, right: 0.0)
	static let contentPadding = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
}

struct RegisterView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State private(set) var loadable: Loadable<Bool> = .notRequested

	// MARK: - Init

	// MARK: - Body
	var body: some View {
		GeometryReader { _ in
			ScrollView(showsIndicators: false) {
				AppTheme.shared.imageSet.logo
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.logoSize.width, height: Constants.logoSize.height)
					.padding(.top, Constants.logoPadding.top)
					.padding(.bottom, Constants.logoPadding.bottom)
				content
					.padding(.horizontal, Constants.contentPadding.left)
			}
			.keyboardAdaptive()
		}
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.hideKeyboardOnTapped()
	}
}

// MARK: - Private variable
private extension RegisterView {
	var backgroundColorView: LinearGradient {
		colorScheme == .light ? backgroundColorGradient : backgroundColorBlack
	}

	var backgroundColorBlack: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundColorGradient: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Private
private extension RegisterView {
	var content: AnyView {
		switch loadable {
		case .notRequested:
			return AnyView(notRequestedView)
		case .isLoading:
			return AnyView(loadingView)
		case .loaded:
			return AnyView(loadedView)
		case .failed(let error):
			return AnyView(errorView(RegisterViewError(error)))
		}
	}
}

// MARK: - Loading Content
private extension RegisterView {
	var notRequestedView: some View {
		RegisterContentView(loadable: $loadable)
	}
	
	var loadingView: some View {
		notRequestedView.modifier(LoadingIndicatorViewModifier())
	}
	
	var loadedView: some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text("Register.Success.Title".localized),
					  message: Text("Register.Success.Message".localized),
					  dismissButton: .default(Text("General.OK".localized), action: {
					presentationMode.wrappedValue.dismiss()
				}))
			}
	}
	
	func errorView(_ error: RegisterViewError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text(error.title),
					  message: Text(error.message),
					  dismissButton: .default(Text(error.primaryButtonTitle)))
			}
	}
}

// MARK: - Interactors

// MARK: - Preview
#if DEBUG
struct RegisterView_Previews: PreviewProvider {
	static var previews: some View {
		RegisterView()
	}
}
#endif

public class KeyboardInfo: ObservableObject {

	public static var shared = KeyboardInfo()

	@Published public var height: CGFloat = 0

	private init() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIApplication.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}

	@objc func keyboardChanged(notification: Notification) {
		if notification.name == UIApplication.keyboardWillHideNotification {
			self.height = 0
		} else {
			self.height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
		}
	}

}

struct KeyboardAware: ViewModifier {
	@ObservedObject private var keyboard = KeyboardInfo.shared

	func body(content: Content) -> some View {
		content
			.padding(.bottom, self.keyboard.height)
			.edgesIgnoringSafeArea(self.keyboard.height > 0 ? .bottom : [])
	}
}

extension View {
	public func keyboardAware() -> some View {
		ModifiedContent(content: self, modifier: KeyboardAware())
	}
}
