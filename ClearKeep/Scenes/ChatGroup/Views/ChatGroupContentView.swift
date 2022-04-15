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
		VStack(spacing: Constants.paddingVertical) {
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
			
			HStack {
				Text("Alissa Baker".localized)
					.font(AppTheme.shared.fontSet.font(style: .body3))
					.foregroundColor(foregroundTagUser)
					.padding([.leading, .top, .bottom], Constants.paddingTagUser)
				Button(action: {
					
				}, label: {
					Button {
						
					} label: {
						AppTheme.shared.imageSet.crossIcon
							.foregroundColor(foregroundCrossIcon)
							.padding(.trailing, Constants.paddingTagUser)
					}
				})
			}
			.background(backgroundTagUser)
			.cornerRadius(Constants.cornerRadiusTagUser)
			.frame(maxWidth: .infinity, alignment: .leading)
			.frame(height: Constants.heightTagUser)
			
			CheckBoxButtons(text: "GroupChat.User.Add.Title".localized, isChecked: $isShowingView)
				.frame(maxWidth: .infinity, alignment: .leading)
			
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
				VStack {
					HStack {
						ZStack {
							Circle()
								.fill(backgroundGradientPrimary)
								.frame(width: Constants.sizeImage, height: Constants.sizeImage)
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
			Spacer()
		}
		.padding(.horizontal, Constants.paddingVertical)
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.edgesIgnoringSafeArea(.all)
		.navigationBarTitle("")
		.navigationBarHidden(true)
	}
}

private extension ChatGroupContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Color func
private extension ChatGroupContentView {
	
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

struct ChatGroupContentView_Previews: PreviewProvider {
	static var previews: some View {
		ChatGroupContentView()
	}
}
