//
//  SwiftUIView.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let paddingButtonNext = 60.0
	static let sizeImage = 64.0
}

struct CreateGroupView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@State private var nameGroup = ""
	@State private(set) var nameGroupStyle: TextInputStyle = .default
	@State private(set) var isCreateGroup: Bool = false
	var model: [GroupChatModel] = []

	let inspection = ViewInspector<Self>()

	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.paddingVertical)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
			.applyNavigationBarPlainStyle(title: "",
										  titleColor: AppTheme.shared.colorSet.offWhite,
										  backgroundColors: backgroundButtonBack,
										  leftBarItems: {
				buttonBackView
			},
										  rightBarItems: {
				Spacer()
			})
	}
}

// MARK: - Private
private extension CreateGroupView {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension CreateGroupView {
	var contentView: some View {
		VStack {
			groupNameView
			listUserView
			buttonNextView
			Spacer()
		}
	}
	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacer) {
				AppTheme.shared.imageSet.chevleftIcon
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

	var groupNameView: some View {
		VStack(alignment: .leading) {
			Text("GroupChat.Group.Name".localized)
				.font(AppTheme.shared.fontSet.font(style: .body2))
				.foregroundColor(foregroundButtonBack)

			CommonTextField(text: $nameGroup,
							inputStyle: $nameGroupStyle,
							inputIcon: Image(""),
							placeHolder: "GroupChat.Named".localized,
							keyboardType: .default,
							onEditingChanged: { isEditing in
				if isEditing {
					nameGroupStyle = .normal
				} else {
					nameGroupStyle = .highlighted
				}
			})
			Text("GroupChat.User.Inside".localized)
				.foregroundColor(foregroundText)
				.font(AppTheme.shared.fontSet.font(style: .input2))
		}
	}

	var listUserView: some View {
		List(model, id: \.id) { item in
			HStack {
				ZStack {
					Circle()
						.fill(backgroundGradientPrimary)
						.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					AppTheme.shared.imageSet.userIcon
				}
				Text(item.name)
					.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(Color.gray)
			}
		}
		
			.listStyle(PlainListStyle())
		
	}

	var buttonNextView: some View {
		NavigationLink(
			destination: EmptyView(),
			label: {
				Button(action: { },
					   label: {
					Text("GroupChat.Create".localized)
				})
					.frame(maxWidth: .infinity)
					.frame(height: Constants.heightButton)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.background(backgroundGradientPrimary)
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
					.cornerRadius(Constants.cornerRadiusButtonNext)
					.padding(.horizontal, Constants.spacerTopView)
			})
			.padding(.bottom, Constants.paddingButtonNext)
	}
}

// MARK: - Color func
private extension CreateGroupView {
	var foregroundButtonBack: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}

	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var foregroundText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight
	}
}

// MARK: - Private Func
private extension CreateGroupView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Preview
#if DEBUG
struct CreateGroupView_Previews: PreviewProvider {
	static var previews: some View {
		CreateGroupView()
	}
}
#endif
