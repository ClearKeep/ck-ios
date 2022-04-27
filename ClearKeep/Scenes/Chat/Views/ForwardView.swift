//
//  ForwardView.swift
//  ClearKeep
//
//  Created by Quang Pham on 29/04/2022.
//

// swiftlint:disable multiple_closures_with_trailing_closure

import SwiftUI
import Common
import CommonUI
import Model
import Networking

private enum Constants {
	static let spacing = 17.0
	static let padding = 15.0
	static let sizeImage = 64.0
	static let paddingHorizontal = 50.0
	static let buttonBorder = 2.0
	static let searchViewHeight = 52.0
	static let searchViewRadius = 16.0
}

struct ForwardView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var searchText: String = ""
	@State private(set) var inputStyle: TextInputStyle
	@State private var shouldShowCancelButton: Bool = false
	
	private let inspection = ViewInspector<Self>()
	
	private let fakeGroup: [String] = ["UI Design", "Backend Development", "Discussion"]
	private let fakeUser: [String] = ["Alex Mendes", "Alissa Baker", "John Doe"]

	// MARK: - Init
	init(inputStyle: TextInputStyle) {
		self._inputStyle = .init(initialValue: inputStyle)
	}

	// MARK: - Body
	var body: some View {
		content
			.edgesIgnoringSafeArea(.all)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension ForwardView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
	
	var searchView: some View {
		HStack(alignment: .center, spacing: 0) {
			AppTheme.shared.imageSet.searchIcon
				.foregroundColor(searchTintColor)
				.padding(.horizontal, 18.0)
			TextField("", text: $searchText)
				.introspectTextField { textfield in
					textfield.returnKeyType = .search
				}
				.background(
					HStack {
						Text("Chat.Input.PlaceHolder".localized)
							.opacity(shouldShowCancelButton ? 0 : 1)
						Spacer()
					}
				)
				.accentColor(textColor)
				.onChange(of: searchText) {
					shouldShowCancelButton = $0.count > 0
				}
				.font(inputStyle.textStyle.font)
				.foregroundColor(textColor)
				.padding(.horizontal, 8)
				.frame(height: Constants.searchViewHeight)
			Button(action: { searchText = "" }) {
				AppTheme.shared.imageSet.closeIcon
					.foregroundColor(searchTintColor)
					.padding(.trailing, 18)
			}.opacity(shouldShowCancelButton ? 1 : 0)
		}.background(searchBackgroundColor)
			.cornerRadius(Constants.searchViewRadius)
	}

	var groupView: some View {
		VStack(spacing: Constants.spacing) {
			ForEach(fakeGroup, id: \.self) { name in
				HStack {
					Text(name)
						.lineLimit(1)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(foregroundColorGroupName)
					Spacer()
					Button(action: sendAction) {
							Text("Chat.Send".localized)
							.frame(width: 120, height: 40)
							.foregroundStyle(buttonColor)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.overlay(
								Capsule().stroke(buttonColor, lineWidth: Constants.buttonBorder)
							)
					}.padding(.horizontal, 1)
				}
			}
		}
		
	}

	var userView: some View {
		VStack(spacing: Constants.spacing) {
			ForEach(fakeUser, id: \.self) { name in
				HStack {
					AppTheme.shared.imageSet.faceIcon
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.sizeImage, height: Constants.sizeImage)
						.clipShape(Circle())
					Text(name)
						.lineLimit(1)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(foregroundColorUserName)
					Spacer()
					Button(action: sendAction) {
						Text("Chat.Send".localized)
							.frame(width: 132.5, height: 32)
							.foregroundStyle(buttonColor)
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.overlay(
								Capsule().stroke(buttonColor, lineWidth: Constants.buttonBorder)
							)
					}.padding(.horizontal, 1)
				}
			}
		}
	}
}

// MARK: - Private variable
private extension ForwardView {
	
	var searchBackgroundColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey5 : Color(UIColor(hex: "#9E9E9E"))
	}
	
	var searchTintColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.darkGrey2
	}
	
	var textColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.darkGrey2
	}

	var foregroundColorTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundColorGroupName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var buttonColor: LinearGradient {
		colorScheme == .light ? foregroundButtonLight : foregroundButtonDark
	}

	var foregroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: [AppTheme.shared.colorSet.primaryDefault, AppTheme.shared.colorSet.primaryDefault]), startPoint: .topLeading, endPoint: .bottomTrailing)
	}

	var foregroundButtonLight: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .topLeading, endPoint: .bottomTrailing)
	}
}

// MARK: - Private
private extension ForwardView {
	func sendAction() {

	}
}

// MARK: - Loading Content
private extension ForwardView {
	var notRequestedView: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("Chat.Forward".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundColorGroupName)
				.padding(.vertical, Constants.spacing)
			searchView.padding(.bottom, Constants.spacing)
			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading, spacing: Constants.spacing) {
					Text("Chat.Group".localized)
						.font(AppTheme.shared.fontSet.font(style: .input3))
						.foregroundColor(foregroundColorTitle)
					groupView
					Text("Chat.User".localized)
						.font(AppTheme.shared.fontSet.font(style: .input3))
						.foregroundColor(foregroundColorTitle)
					userView
				}
			}
		}
		.padding(.horizontal, Constants.padding)
		.padding(.bottom, 30)
		.hideKeyboardOnTapped()
	}
	
	var loadingView: some View {
		notRequestedView.progressHUD(true)
	}
	
	func loadedView() -> AnyView {
		return AnyView(notRequestedView)
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

// MARK: - Interactor
private extension ForwardView {
}

// MARK: - Preview
#if DEBUG
struct ForwardView_Previews: PreviewProvider {
	static var previews: some View {
		ForwardView(inputStyle: .default)
	}
}
#endif
