//
//  ChatGroupView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
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

struct ChatGroupView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IGroupChatModel]>
	@State private(set) var searchText: String
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var isShowingView: Bool = false
	@State private(set) var isSelectedUser: Bool = false
	@State private(set) var model: [GroupChatModel]
	@State private(set) var name: String = ""
	
	// MARK: - Init
	public init(samples: Loadable<[IGroupChatModel]> = .notRequested,
				searchText: String = "",
				model: [GroupChatModel],
				inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._searchText = .init(initialValue: searchText)
		self._model = .init(initialValue: model)
	}
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			VStack(spacing: Constants.paddingVertical) {
				buttonBack
				inputSearch
				tagUser
				checkbox

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
			}
			.padding(.horizontal, Constants.paddingVertical)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.edgesIgnoringSafeArea(.all)
		}
	}
}

// MARK: - Private
private extension ChatGroupView {
	var buttonBack: AnyView {
		AnyView(buttonBackView)
	}
	
	var inputSearch: AnyView {
		AnyView(inputSearchView)
	}
	
	var tagUser: AnyView {
		AnyView(tagView)
	}

	var checkbox: AnyView {
		AnyView(checkboxListUser)
	}

	var listUser: AnyView {
		AnyView(listUserView)
	}

	var buttonNext: AnyView {
		AnyView(buttonNextView)
	}
}

// MARK: - Loading Content
private extension ChatGroupView {
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
		.padding(.top, Constants.spacerTopView)
	}
	
	var inputSearchView: some View {
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
			.padding(.top, Constants.paddingVertical)
	}
	
	var tagView: some View {
		TagView(groupChatModel: [GroupChatModel(name: "absbd"),
								 GroupChatModel(name: "mvxcvmkdfkgdf"),
								 GroupChatModel(name: "kdrgjkerkter"),
								 GroupChatModel(name: "absbd"),
								 GroupChatModel(name: "kkjgkegjrktekrtert"),
								 GroupChatModel(name: "sdkfskfksdf"),
								 GroupChatModel(name: "sldfksldfklwelr"),
								 GroupChatModel(name: "ewrlwkrlewkr"),
								 GroupChatModel(name: "dfgdfgdfg")])
	}

	var checkboxListUser: some View {
		CheckBoxButtons(text: "GroupChat.User.Add.Title".localized, isChecked: $isShowingView)
			.frame(maxWidth: .infinity, alignment: .leading)
	}

	var listUserView: some View {
			List(0..<model.count, id: \.self) { index in
				ListUser(name: $model[index].name)
			}
			.listStyle(PlainListStyle())
	}

	var buttonNextView: some View {
		NavigationLink(
			destination: EmptyView(),
			label: {
				Button(action: { },
					   label: {
					Text("GroupChat.Next".localized)
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

// MARK: - Interactor
private extension ChatGroupView {
}

// MARK: - Private Func
private extension ChatGroupView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Color func
private extension ChatGroupView {
	var foregroundCrossIcon: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundButtonBack: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}
	
	var backgroundTagUser: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey5 : AppTheme.shared.colorSet.primaryDefault
	}
	
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
}

// MARK: - Preview
#if DEBUG
struct ChatGroupView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupView(model: [])
	}
}
#endif
