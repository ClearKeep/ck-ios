//
//  GroupDetailContent.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let padding = 20.0
	static let sizeImage = 36.0
	static let sizeIconCall = 16.0
	static let sizeBoder = 36.0
	static let lineBoder = 2.0
	static let paddingHorizontal = 40.0
	static let paddingTop = 50.0
	static let sizeOffset = 26.0
	static let sizeIcon = 16.0
}

struct DetailContentView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String
	@Binding var groupText: String
	@State private(set) var isChangeSeeMemberView: Bool = false
	@State private(set) var isChangeAddMemberView: Bool = false
	@State private(set) var isChangeRemoveMemberView: Bool = false
	@State private(set) var isChangeHomeView: Bool = false
	
	// MARK: - Init
	init(imageUser: Binding<Image>,
		 userName: Binding<String>,
		 groupText: Binding<String>) {
		self._imageUser = imageUser
		self._userName = userName
		self._groupText = groupText
	}
	
	// MARK: - Body
	var body: some View {
		content
			.padding(.horizontal, Constants.padding)
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.edgesIgnoringSafeArea(.all)
			.background(backgroundColorView)
	}
}

// MARK: - Private
private extension DetailContentView {
	var content: AnyView {
		AnyView(contentView)
	}
	
	var buttonBack: AnyView {
		AnyView(buttonBackView)
	}
	
	var userView: AnyView {
		AnyView(imageUserView)
	}
	
	var audioButton: AnyView {
		AnyView(audioButtonView)
	}
	
	var videoButton: AnyView {
		AnyView(videoButtonView)
	}
	var listButton: AnyView {
		AnyView(listbuttonView)
	}
}

// MARK: - Private Variables
private extension DetailContentView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var foregroundButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.primaryDefault : AppTheme.shared.colorSet.primaryDefault
	}

	var foregroundButtonImage: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
	
	var foregroundText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundSignout: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.errorDefault : AppTheme.shared.colorSet.primaryDefault
	}
}

// MARK: - Private func
private extension DetailContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func seeMemberAction() {
		isChangeSeeMemberView = true
	}
	
	func addMemberAction() {
		isChangeAddMemberView = true
	}
	
	func removeMemberAction() {
		isChangeRemoveMemberView = true
	}
	
	func signOut() {
		isChangeHomeView = true
	}

	func audioAction() {

	}

	func videoAction() {

	}
}

// MARK: - Loading Content
private extension DetailContentView {
	var contentView: some View {
		VStack {
			buttonBack
				.padding(.top, Constants.paddingTop)
				.frame(maxWidth: .infinity, alignment: .leading)
			userView
				.padding(.horizontal)
			HStack(alignment: .center) {
				audioButton
				Spacer()
				videoButton
			}
			.padding(.horizontal, Constants.paddingHorizontal)
			listButton
			Spacer()
		}
	}
	
	var imageUserView: some View {
		HStack(alignment: .center) {
			ZStack {
				ZStack {
					Circle()
						.fill(foregroundButtonImage)
						.frame(width: Constants.sizeBoder, height: Constants.sizeBoder)
					Text("+3")
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				AppTheme.shared.imageSet.facebookIcon
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
					.offset(x: -Constants.sizeOffset)
				Spacer()
			}
		}
	}
	
	var audioButtonView: some View {
		Button(action: audioAction) {
			VStack {
				ZStack {
					AppTheme.shared.imageSet.phoneCallIcon
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.foregroundColor(foregroundButton)
						.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
					Circle()
						.strokeBorder(foregroundButton, lineWidth: Constants.lineBoder)
						.frame(width: Constants.sizeBoder, height: Constants.sizeBoder)
				}
				Text("General.Audio".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundButton)
			}
		}
	}
	
	var videoButtonView: some View {
		Button(action: videoAction) {
			VStack {
				ZStack {
					AppTheme.shared.imageSet.videoIcon
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.foregroundColor(foregroundButton)
						.frame(width: Constants.sizeIconCall, height: Constants.sizeIconCall)
					Circle()
						.strokeBorder(foregroundButton, lineWidth: Constants.lineBoder)
						.frame(width: Constants.sizeBoder, height: Constants.sizeBoder)
				}
				Text("General.Video".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundButton)
			}
		}
	}
	
	var listbuttonView: some View {
		VStack {
			NavigationLink(
				destination: MemberView(imageUser: $imageUser, userName: $userName),
				isActive: $isChangeSeeMemberView,
				label: {
					Button(action: seeMemberAction) {
						HStack {
							AppTheme.shared.imageSet.userIcon
								.resizable()
								.renderingMode(.template)
								.aspectRatio(contentMode: .fit)
								.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
								.padding(.all, Constants.padding)
								.foregroundColor(foregroundText)
							Text("GroupDetail.SeeMembers".localized)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundText)
							Spacer()
						}
					}
				})
			NavigationLink(
				destination: AddMemberView(imageUser: $imageUser, userName: $userName, searchText: .constant(""), inputStyle: .constant(.default)),
				isActive: $isChangeAddMemberView,
				label: {
					Button(action: addMemberAction) {
						HStack {
							AppTheme.shared.imageSet.usersPlusIcon
								.resizable()
								.renderingMode(.template)
								.aspectRatio(contentMode: .fit)
								.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
								.padding(.all, Constants.padding)
								.foregroundColor(foregroundText)
							Text("GroupDetail.AddMember".localized)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundText)
							Spacer()
						}
					}
				})
			NavigationLink(
				destination: RemoveMemberView(imageUser: $imageUser, userName: $userName, searchText: .constant(""), inputStyle: .constant(.default)),
				isActive: $isChangeRemoveMemberView,
				label: {
					Button(action: removeMemberAction) {
						HStack {
							AppTheme.shared.imageSet.userOfflineIcon
								.resizable()
								.renderingMode(.template)
								.aspectRatio(contentMode: .fit)
								.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
								.padding(.all, Constants.padding)
								.foregroundColor(foregroundText)
							Text("GroupDetail.RemoveMember".localized)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(foregroundText)
							Spacer()
						}
					}
				})
			Button(action: signOut) {
				HStack {
					AppTheme.shared.imageSet.logoutIcon
						.resizable()
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
						.padding(.all, Constants.padding)
						.foregroundColor(foregroundSignout)
					Text("Home.Signout".localized)
						.font(AppTheme.shared.fontSet.font(style: .body3))
						.foregroundColor(foregroundSignout)
					Spacer()
				}
			}
		}
	}
	
	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacing) {
				AppTheme.shared.imageSet.chevleftIcon
					.renderingMode(.template)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text(groupText)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body1))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Interactor
private extension DetailContentView {
}

// MARK: - Preview
#if DEBUG
struct DetailContentView_Previews: PreviewProvider {
	static var previews: some View {
		DetailContentView(imageUser: .constant(Image("")), userName: .constant(""), groupText: .constant(""))
	}
}
#endif
