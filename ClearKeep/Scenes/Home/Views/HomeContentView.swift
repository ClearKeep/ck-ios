//
//  HomeContentView.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import SwiftUI
private enum Constants {
	static let spacing = 20.0
	static let spacingLeading = 10.0
	static let paddingTop = 50.0
	static let paddingLeading = 100.0
	static let padding = 20.0
	static let sizeImage = 32.0
	static let sizeCircle = 8.0
	static let sizeOffset = 5.0
	static let sizeIcon = 24.0
}

struct HomeContentView: View {
	// MARK: - Variable
	@Environment(\.colorScheme) var colorScheme
	@State private(set) var isExpandGroup: Bool
	@State private(set) var isExpandMessage: Bool
	@State private(set) var isAddAction: Bool
	@State private(set) var isChangeStatus: Bool
	@State private(set) var group: [String] = ["Discussion", "UI Design", "Front-end Development", "Back-end Development"]
	@State private(set) var userName: [String] = ["Alex", "Alisa", "babara", "Jonh Doe"]
	@State private(set) var isGroup: Bool = false
	
	// MARK: - Body
	var body: some View {
		content
	}
}

// MARK: - Private
private extension HomeContentView {
	var content: AnyView {
		AnyView(bodyView)
	}
	
	var groupChat: AnyView {
		AnyView(groupView)
	}
	
	var directMessages: AnyView {
		AnyView(directMessagesView)
	}
}

// MARK: - Private variable
private extension HomeContentView {
	var expandGroupImage: Image {
		isExpandGroup ? AppTheme.shared.imageSet.chevDownIcon : AppTheme.shared.imageSet.chevRightIcon
	}
	
	var expandMessageImage: Image {
		isExpandMessage ? AppTheme.shared.imageSet.chevDownIcon : AppTheme.shared.imageSet.chevRightIcon
	}
	
	var foregroundStatusView: Color {
		isChangeStatus ? AppTheme.shared.colorSet.successDefault : AppTheme.shared.colorSet.errorDefault
	}
	
	var foregroundTitle: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.offWhite
	}
	
	var foregroundBody: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.grey5
	}
	
	var opacityGroup: Double {
		isExpandGroup ? 1 : 0
	}
	
	var opacityMessage: CGFloat {
		isExpandMessage ? 1 : 0
	}
	
	var frameGroup: CGFloat? {
		isExpandGroup ? nil : 0
	}
	
	var frameMessage: CGFloat? {
		isExpandMessage ? nil : 0
	}
}

// MARK: - Private func
private extension HomeContentView {
	func expandGroups() {
		isExpandGroup.toggle()
	}
	
	func expandMessages() {
		isExpandMessage.toggle()
	}
	
	func addAction() {
		isAddAction.toggle()
	}
	
	func changeView() {
		
	}
}

// MARK: - Displaying Content
private extension HomeContentView {
	var bodyView: some View {
		VStack(spacing: 22) {
			groupChat
			directMessages
		}
	}
	
	var groupView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			HStack {
				Button(action: expandGroups) {
					HStack {
						Text("Home.GroupChat".localized)
							.font(AppTheme.shared.fontSet.font(style: .body2))
							.foregroundColor(foregroundTitle)
						expandGroupImage
							.resizable()
							.renderingMode(.template)
							.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
							.foregroundColor(foregroundTitle)
					}
				}
				Spacer()
				NavigationLink(destination: ChatGroupView(),
							   isActive: $isGroup,
							   label: {
					AppTheme.shared.imageSet.plusIcon
						.resizable()
						.renderingMode(.template)
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
						.foregroundColor(foregroundTitle)
				})
			}
			VStack(alignment: .leading, spacing: Constants.spacing) {
				ForEach(group, id: \.self) { groups in
					Button(action: changeView ) {
						Text(groups)
							.font(AppTheme.shared.fontSet.font(style: .input3))
							.foregroundColor(foregroundBody)
					}
				}
				.padding(.leading, Constants.spacingLeading)
			}
			.opacity(opacityGroup)
			.frame(height: frameGroup)
			.padding(.leading, Constants.padding)
		}
	}
	
	var directMessagesView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			HStack {
				Button(action: expandMessages) {
					HStack {
						Text("Home.Message".localized)
							.font(AppTheme.shared.fontSet.font(style: .body2))
							.foregroundColor(foregroundTitle)
						expandMessageImage
							.resizable()
							.renderingMode(.template)
							.aspectRatio(contentMode: .fit)
							.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
							.foregroundColor(foregroundTitle)
					}
				}
				Spacer()
				Button(action: addAction) {
					AppTheme.shared.imageSet.plusIcon
						.resizable()
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
						.foregroundColor(foregroundTitle)
				}
			}
			VStack(alignment: .leading, spacing: Constants.spacing) {
				ForEach(userName, id: \.self) { name in
					HStack {
						ZStack {
							AppTheme.shared.imageSet.facebookIcon
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: Constants.sizeImage, height: Constants.sizeImage)
								.clipShape(Circle())
								.padding(.leading, Constants.padding)
								.padding(.bottom, Constants.padding)
							Circle()
								.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
								.offset(x: Constants.padding)
								.foregroundColor(foregroundStatusView)
						}
						Button(action: changeView) {
							Text(name)
								.font(AppTheme.shared.fontSet.font(style: .input3))
								.foregroundColor(foregroundBody)
						}
						.padding(.leading, Constants.spacingLeading)
						Spacer()
					}
				}
			}
			.opacity(opacityMessage)
			.frame(height: frameMessage)
			.padding(.leading, Constants.padding)
		}
	}
}

// MARK: - Preview
#if DEBUG
struct HomeContentView_Previews: PreviewProvider {
	static var previews: some View {
		HomeContentView(isExpandGroup: false, isExpandMessage: false, isAddAction: false, isChangeStatus: false)
	}
}
#endif
