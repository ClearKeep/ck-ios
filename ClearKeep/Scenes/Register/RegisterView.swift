import SwiftUI
import Combine
import Common
import CommonUI
import Networking

private enum Constants {
	static let spacing = 40.0
	static let paddingtop = 80.0
	static let padding = 20.0
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
		content
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
			guard let error = error as? IServerError else {
				return AnyView(errorView(ServerError.unknown))
			}
			return AnyView(errorView(error))
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
	
	func errorView(_ error: IServerError) -> some View {
		return notRequestedView
			.alert(isPresented: .constant(true)) {
				Alert(title: Text("General.Error".localized),
					  message: Text(error.message ?? "General.Unknown".localized),
					  dismissButton: .default(Text("General.OK".localized)))
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
