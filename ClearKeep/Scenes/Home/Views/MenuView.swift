//
//  MenuView.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
import CommonUI
import Common

private enum Constants {
	static let cornerRadius = 32.0
	static let padding = 20.0
	static let frameRatio = 2.0 / 3.0
	static let itemHeight = 32.0
	static let nameHeight = 28.0
	static let statusHeight = 24.0
	static let urlHeight = 18.0
	static let spacing = 4.0
	static let arrowSize = CGSize(width: 6.75, height: 3.75)
	static let statusSizeCircle = CGSize(width: 12.0, height: 12.0)
	static let statusOffset = UIOffset(horizontal: -20.0, vertical: 20.0)
	static let avatarSize = CGSize(width: 56.0, height: 56.0)
	static let statusSize = CGSize(width: 165, height: 45.0)
	static let opacity = 0.4
	static let sizeCircle = 12.0
	static let paddingStatus = 7.0
}

struct MenuView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.injected) private var injected: DIContainer

	@Binding var isShowMenu: Bool
	@State private var userProfile: String = ""
	@Binding var user: [UserViewModel]
	@State private var isShowToastCopy: Bool = false
	@State private(set) var isExpand: Bool = false
	var chageStatus: (StatusType) -> Void
	let profile = DependencyResolver.shared.channelStorage.currentServer?.profile

	// MARK: - Init

	// MARK: - Body
	var body: some View {
		GeometryReader { geometry in
			HStack {
				Spacer()
				VStack(alignment: .trailing) {
					HStack {
						Spacer()
						ImageButton(AppTheme.shared.imageSet.closeIcon.renderingMode(.template)) { isShowMenu.toggle() }
						.foregroundColor(AppTheme.shared.colorSet.grey1)
					}
					ZStack(alignment: .trailing) {
						VStack {
							ForEach([StatusType.online, StatusType.busy], id: \.self) { status in
								HStack {
									Circle()
										.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
										.foregroundColor(didSelectColorStatus(status))
									LinkButton(status.title, alignment: .leading, action: { self.didSelectStatus(status) })
										.foregroundColor(AppTheme.shared.colorSet.black)
										.font(AppTheme.shared.fontSet.font(style: .input3))
								}
								.frame(width: Constants.statusSize.width, height: Constants.statusSize.height)
								.opacity(1)
								.padding(.horizontal, Constants.paddingStatus)
							}
						}
						.background(backgroundColorMenu)
						.cornerRadius(Constants.spacing)
						.shadow(color: AppTheme.shared.colorSet.black.opacity(Constants.opacity), radius: Constants.spacing)
						.opacity(opacityAction)
						.zIndex(2)
						VStack {
							HStack(alignment: .top) {
								ZStack {
									AvatarDefault(.constant(profile?.userName ?? ""), imageUrl: profile?.avatar ?? "")
										.frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
									Group {
										VStack {
											HStack {
												Spacer()
												Circle()
													.frame(width: Constants.statusSizeCircle.width, height: Constants.statusSizeCircle.height)
													.foregroundColor(Color.green)
											}
											Spacer()
										}.frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
									}
								}

								VStack(alignment: .leading, spacing: Constants.spacing) {
									Text(user.first?.displayName ?? (profile?.userName ?? "Name"))
										.font(AppTheme.shared.fontSet.font(style: .body2))
										.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
										.frame(height: Constants.nameHeight)
									Button(action: expandAction) {
										HStack {
											Text(self.user.first?.status.title ?? "")
												.font(AppTheme.shared.fontSet.font(style: .input3))
												.foregroundColor(self.user.first?.status.color ?? AppTheme.shared.colorSet.successDefault)
											AppTheme.shared.imageSet.chevDownIcon
												.renderingMode(.template)
												.aspectRatio(contentMode: .fit)
												.frame(width: Constants.arrowSize.width, height: Constants.arrowSize.height)
												.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight)
										}
									}
									.frame(height: Constants.statusHeight)
									HStack {
										Text(getLinkUrl())
											.font(AppTheme.shared.fontSet.font(style: .input3))
											.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight)
										Spacer()
										ImageButton(AppTheme.shared.imageSet.copyIcon.renderingMode(.template), action: copyAction)
											.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
									}
									.frame(height: Constants.urlHeight)
								}

							}
							Divider()
								.background(colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight)
							ForEach(MenuType.allCases, id: \.self) { menu in
								LinkButton(menu.title, icon: menu.icon, alignment: .leading) { didSelectMenu(menu) }
								.foregroundColor(foregroundMenuType)
								.frame(height: Constants.itemHeight)
							}
						}
					}
					Spacer()
					LinkButton("Home.SignOut".localized, icon: AppTheme.shared.imageSet.logoutIcon, alignment: .center, action: signOutAction)
						.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.errorDefault : AppTheme.shared.colorSet.primaryDefault)
						.frame(height: Constants.itemHeight)
				}
				.padding(Constants.padding)
				.background(
					RoundedCorner(radius: Constants.cornerRadius, rectCorner: [.topLeft, .bottomLeft])
						.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.darkgrey3)
				)
				.frame(width: geometry.size.width * Constants.frameRatio)
				.frame(maxHeight: .infinity)
				.padding(.vertical, Constants.padding)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}.toast(message: "Menu.Copy.Title".localized, isShowing: $isShowToastCopy, duration: Toast.short)
	}
}

// MARK: - Actions
private extension MenuView {
	func signOutAction() {
		Task {
			await injected.interactors.homeInteractor.worker.signOut()
		}
	}

	func copyAction() {
		let currentDomain = DependencyResolver.shared.channelStorage.currentDomain
		let user = DependencyResolver.shared.channelStorage.currentServer?.profile
		UIPasteboard.general.string = "\(currentDomain)/\(user?.userName.replacingOccurrences(of: " ", with: "") ?? "name")/\(user?.userId ?? "id")"
		self.isShowToastCopy = true
	}

	func statusAction() {

	}

	func expandAction() {
		self.isExpand.toggle()
	}

	func didSelectMenu(_ menu: MenuType) {

	}

	func didSelectStatus(_ status: StatusType) {
		if self.user.first?.status == status {
			return
		}
		self.chageStatus(status)
	}

	func didSelectColorStatus(_ status: StatusType) -> Color {
		switch status {
		case .online:
			return AppTheme.shared.colorSet.successDefault
		case .ofline:
			return AppTheme.shared.colorSet.grey1
		case .busy:
			return AppTheme.shared.colorSet.errorDefault
		case .undefined:
			return AppTheme.shared.colorSet.successDefault
		}
	}

	func getLinkUrl() -> String {
		let currentDomain = DependencyResolver.shared.channelStorage.currentDomain
		let user = DependencyResolver.shared.channelStorage.currentServer?.profile
		return "\(currentDomain)/\(user?.userName ?? "name")/\(user?.userId ?? "id")"
	}
}

private extension MenuView {
	var backgroundColor: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}

	var foregroundStatusText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.black
	}

	var foregroundMenuType: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}

	var backgroundColorMenu: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.darkgrey3
	}

	var opacityAction: Double {
		isExpand ? 1 : 0
	}
}
