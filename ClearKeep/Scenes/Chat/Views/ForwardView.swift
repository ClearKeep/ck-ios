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
	static let paddingHorizontal = 50.0
	static let buttonBorder = 2.0
	static let searchViewHeight = 52.0
	static let searchViewRadius = 16.0
	static let sizeImage = CGSize(width: 64.0, height: 64.0)
}

struct ForwardView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@State private var searchText: String = ""
	@State private(set) var inputStyle: TextInputStyle
	@State private var shouldShowCancelButton: Bool = false
		
	@Binding private var groups: [ForwardViewModel]
	@Binding private var users: [ForwardViewModel]
	
	@State private var allUsers = [ForwardViewModel]()
	@State private var allGroups = [ForwardViewModel]()
	@State private var firstTimeSearch = true
	
	private var onForwardMessage: (Bool, ForwardViewModel) -> Void
	
	private let inspection = ViewInspector<Self>()

	// MARK: - Init
	init(inputStyle: TextInputStyle, groups: Binding<[ForwardViewModel]>, users: Binding<[ForwardViewModel]>, onForwardMessage: @escaping (Bool, ForwardViewModel) -> Void) {
		self._inputStyle = .init(initialValue: inputStyle)
		self._groups = groups
		self._users = users
		self.onForwardMessage = onForwardMessage
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
	var content: some View {
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
	
	var searchView: some View {
		HStack(alignment: .center, spacing: 0) {
			AppTheme.shared.imageSet.searchIcon
				.foregroundColor(searchTintColor)
				.padding(.horizontal, 18.0)
			TextField("", text: $searchText)
				.autocapitalization(.none)
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
					if firstTimeSearch {
						allUsers = users
						allGroups = groups
						firstTimeSearch = false
					}
					groups = allGroups.filter { $0.groupModel.groupName.lowercased().contains(searchText) }
					users = allUsers.filter { $0.groupModel.groupName.lowercased().contains(searchText) }
					if searchText == "" {
						users = allUsers
						groups = allGroups
					}
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
			ForEach(groups, id: \.groupModel.groupId) { group in
				UserView(model: group, isGroup: true, onForwardMessage: { model in
					sendAction(isGroup: true, model: model)
				})
			}
		}
		
	}

	var userView: some View {
		VStack(spacing: Constants.spacing) {
			ForEach(users, id: \.groupModel.groupId) { user in
				UserView(model: user, isGroup: false, onForwardMessage: { model in
					sendAction(isGroup: false, model: model)
				})
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

	var foregroundColorGroupName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private
private extension ForwardView {
	func sendAction(isGroup: Bool, model: ForwardViewModel) {
		onForwardMessage(isGroup, model)
	}
}

private struct UserView: View {
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var model: ForwardViewModel
	var isGroup: Bool
	var onForwardMessage: (ForwardViewModel) -> Void
	
	var body: some View {
		HStack(spacing: 0) {
			if !isGroup {
				MessageAvatarView(avatarSize: Constants.sizeImage,
								  userName: model.groupModel.groupName,
								  font: AppTheme.shared.fontSet.font(style: .input3),
								  image: model.groupModel.groupAvatar
				).padding(.trailing, 16)
			}
			Text(model.groupModel.groupName)
				.lineLimit(1)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(isGroup ? foregroundColorGroupName: foregroundColorUserName)
			Spacer()
			Button(action: { onForwardMessage(model) }) {
				Text(model.isSent ? "Chat.Sent".localized : "Chat.Send".localized)
					.frame(width: isGroup ? 120 : 132, height: isGroup ? 40: 32)
					.foregroundStyle(buttonColor)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.overlay(
						Capsule().stroke(buttonColor, lineWidth: Constants.buttonBorder)
					)
			}.padding(.horizontal, 1)
		}
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
	
	var foregroundColorGroupName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Preview
#if DEBUG
struct ForwardView_Previews: PreviewProvider {
	static var previews: some View {
		ForwardView(inputStyle: .default, groups: .constant([]), users: .constant([]), onForwardMessage: { (_, _) in
			
		})
	}
}
#endif
