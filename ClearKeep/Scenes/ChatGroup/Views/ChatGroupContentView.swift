//
//  GroupChatContentView.swift
//  ClearKeep
//
//  Created by đông on 28/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerTopView = 90.0
	static let spacerBottomView = 20.0
	static let spacer = 25.0
	static let spacerBottom = 45.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let cornerRadiusTagUser = 80.0
	static let sizeImage = 64.0
	static let paddingButtonNext = 60.0
	static let heightTagUser = 40.0
	static let paddingTagUser = 8.0
}

struct ChatGroupContentView: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IGroupChatModel]>
	@State private(set) var searchText: String
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var isShowingView: Bool = false
	@State private(set) var isSelectedUser: Bool = false

	// MARK: - Init
	public init(samples: Loadable<[IGroupChatModel]> = .notRequested,
				searchText: String = "",
				inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._searchText = .init(initialValue: searchText)
	}

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension ChatGroupContentView {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension ChatGroupContentView {
	var contentView: some View {
		VStack(spacing: Constant.paddingVertical) {
			buttonBackView
				.padding(.top, Constant.spacerTopView)
			searchInput.padding(.top, Constant.paddingVertical)
			tagUsers
			addAnotherUserButton
			if isShowingView {
				CommonTextField(text: $searchText,
								inputStyle: $searchStyle,
								placeHolder: "GroupChat.User.Add.Placeholder".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					if isEditing {
						searchStyle = .default
					} else {
						searchStyle = .highlighted
					}
				})
					.frame(maxHeight: .infinity, alignment: .top)
				Spacer()
			} else {
				listUser
			}
			buttonNext
				.padding(.bottom, Constant.paddingButtonNext)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
	}

	var buttonNext: some View {
		NavigationLink(
			destination: EmptyView(),
			label: {
				Button(action: { },
					   label: {
					Text("GroupChat.Next".localized)
				})
					.frame(maxWidth: .infinity)
					.frame(height: Constant.heightButton)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.background(backgroundGradientPrimary)
					.foregroundColor(foregroundColorWhite)
					.cornerRadius(Constant.cornerRadiusButtonNext)
					.padding(.horizontal, Constant.spacerTopView)
			})
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constant.spacer) {
				AppTheme.shared.imageSet.chevleftIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundButtonBack)
				Text("GroupChat.Back.Button".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body1))
					.foregroundColor(foregroundButtonBack)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}

	var searchInput: some View {
		SearchTextField(searchText: $searchText,
						inputStyle: $searchStyle,
						inputIcon: AppTheme.shared.imageSet.searchIcon,
						placeHolder: "GroupChat.Search.Placeholder".localized,
						onEditingChanged: { isEditing in
			if isEditing {
				searchStyle = .normal
			} else {
				searchStyle = .highlighted
			}
		})
	}

	var tagUsers: some View {
		HStack {
			Text("Alissa Baker".localized)
				.font(AppTheme.shared.fontSet.font(style: .body3))
				.foregroundColor(foregroundTagUser)
				.padding([.leading, .top, .bottom], Constant.paddingTagUser)
			Button(action: {

			}, label: {
				Button {

				} label: {
					AppTheme.shared.imageSet.crossIcon
						.renderingMode(.template)
						.foregroundColor(foregroundCrossIcon)
						.padding(.trailing, Constant.paddingTagUser)
				}
			})
		}
		.background(backgroundTagUser)
		.cornerRadius(Constant.cornerRadiusTagUser)
		.frame(maxWidth: .infinity, alignment: .leading)
		.frame(height: Constant.heightTagUser)
	}

	var addAnotherUserButton: some View {
		CheckBoxButtons(text: "GroupChat.User.Add.Title".localized, isChecked: $isShowingView)
			.frame(maxWidth: .infinity, alignment: .leading)
	}

	var listUser: some View {
		VStack {
			HStack {
				ZStack {
					Circle()
						.fill(backgroundGradientPrimary)
						.frame(width: Constant.sizeImage, height: Constant.sizeImage)
					AppTheme.shared.imageSet.userIcon
				}
				Text("Alissa Baker".localized)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(foregroundTagUser)
				CheckBoxButtons(text: "", isChecked: $isSelectedUser)
			}
			Spacer()
		}
	}
}

private extension ChatGroupContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Color func
private extension ChatGroupContentView {
	var foregroundColorWhite: Color {
		AppTheme.shared.colorSet.offWhite
	}

	var foregroundColorBlack: Color {
		AppTheme.shared.colorSet.black
	}

	var foregroundColorPrimary: Color {
		AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundColorGrey5: Color {
		AppTheme.shared.colorSet.grey5
	}

	var foregroundColorGrey1: Color {
		AppTheme.shared.colorSet.grey1
	}

	var foregroundColorGreyLight: Color {
		AppTheme.shared.colorSet.greyLight
	}

	var foregroundCrossIcon: Color {
		colorScheme == .light ? foregroundColorBlack : foregroundColorGreyLight
	}

	var foregroundButtonBack: Color {
		colorScheme == .light ? foregroundColorBlack : foregroundColorWhite
	}

	var foregroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : foregroundColorGreyLight
	}

	var backgroundTagUser: Color {
		colorScheme == .light ? foregroundColorGrey5 : foregroundColorPrimary
	}

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}

struct ChatGroupContentView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupContentView()
	}
}
