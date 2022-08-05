//
//  MenuView.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI
import CommonUI
import Common
import ChatSecure

private enum Constants {
	static let cornerRadius = 32.0
	static let padding = 20.0
	static let frameRatio = 2.0 / 3.0
	static let itemHeight = 32.0
	static let nameHeight = 28.0
	static let statusHeight = 24.0
	static let urlHeight = 18.0
	static let spacing = 4.0
	static let arrowSize = CGSize(width: 12.0, height: 6.0)
	static let statusSize = CGSize(width: 12.0, height: 12.0)
	static let statusOffset = UIOffset(horizontal: -20.0, vertical: 20.0)
	static let avatarSize = CGSize(width: 56.0, height: 56.0)
	static let sizeCircle = 12.0
	static let opacity = 0.4
	static let frameStatus = CGSize(width: 145, height: 45)
	static let offsetFrame = -18.0
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
	var chageStatus: (StatusType) -> Void
	let profile: RealmProfile? = DependencyResolver.shared.channelStorage.currentServer?.profile
	@State private var isProfile: Bool = false
	@State private var isSever: Bool = false
	@State private var isNotification: Bool = false
	@State private(set) var isExpand: Bool = false
	@State private var isShowAlert: Bool = false
	@Binding var servers: [ServerViewModel]
	@State private(set) var customServer: CustomServer = CustomServer()
	
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		GeometryReader { geometry in
			HStack {
				Spacer()
				VStack(alignment: .trailing) {
					ImageButton(AppTheme.shared.imageSet.closeIcon.renderingMode(.template)) { isShowMenu.toggle() }
					.foregroundColor(AppTheme.shared.colorSet.grey1)
					ZStack(alignment: .trailing) {
						VStack {
							HStack {
								ZStack {
									AvatarDefault(.constant(profile?.userName ?? ""), imageUrl: profile?.avatar ?? "")
										.frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
									Circle()
										.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
										.foregroundColor(self.user.first?.status.color ?? AppTheme.shared.colorSet.successDefault)
										.offset(x: Constants.statusOffset.vertical, y: Constants.statusOffset.horizontal)
								}
								VStack(alignment: .leading, spacing: Constants.spacing) {
									Text(profile?.userName ?? "")
										.font(AppTheme.shared.fontSet.font(style: .body2))
										.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
										.frame(height: Constants.nameHeight)
									Button(action: statusAction) {
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
									HStack {
										Text(getLinkUrl())
											.font(AppTheme.shared.fontSet.font(style: .input3))
											.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight)
										Spacer()
										ImageButton(AppTheme.shared.imageSet.copyIcon, action: copyAction)
											.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
									}
									.frame(height: Constants.urlHeight)
								}
							}
							Divider()
								.background(colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight)
								.padding(.vertical, Constants.padding)
							ForEach(MenuType.allCases, id: \.self) { menu in
								didSelect(menu)
							}
						}
						VStack {
							ForEach([StatusType.online, StatusType.busy], id: \.self) { status in
								HStack {
									Circle()
										.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
										.foregroundColor(status.color)
									LinkButton(status.title, alignment: .leading, action: { self.didSelectStatus(status) })
										.foregroundColor(AppTheme.shared.colorSet.black)
										.frame(height: Constants.itemHeight)
										.font(AppTheme.shared.fontSet.font(style: .input3))
								}.padding(.horizontal, Constants.spacing)
									.frame(width: Constants.frameStatus.width, height: Constants.frameStatus.height)
							}
						}
						.background(backgroundColorMenu)
						.cornerRadius(Constants.spacing)
						.shadow(color: AppTheme.shared.colorSet.black.opacity(Constants.opacity), radius: Constants.spacing)
						.opacity(opacityAction)
						.zIndex(2)
						.offset(y: Constants.offsetFrame)
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
			.alert(isPresented: self.$isShowAlert) {
				Alert(title: Text("General.Warning".localized),
					  message: Text("Home.SignOut.Title".localized),
					  primaryButton: .cancel({ self.isShowAlert.toggle() }),
					  secondaryButton: .default(Text("Home.SignOut".localized), action: signOut))
			}
			.hiddenNavigationBarStyle()
	}
}

// MARK: - Actions
private extension MenuView {
	func signOutAction() {
		self.isShowAlert.toggle()
	}

	func signOut() {
		if servers.count < 2 {
			Task {
				await injected.interactors.homeInteractor.signOut()
				await injected.interactors.homeInteractor.removeServer()
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				injected.appState[\.authentication.servers] = []
			})
		} else {
			Task {
				await injected.interactors.homeInteractor.signOut()
				await injected.interactors.homeInteractor.removeServer()
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				NotificationCenter.default.post(name: NSNotification.LogOut, object: nil)
			})
			self.isShowMenu.toggle()
		}
	}

	func copyAction() {
		let currentDomain = DependencyResolver.shared.channelStorage.currentDomain
		let user = DependencyResolver.shared.channelStorage.currentServer?.profile
		UIPasteboard.general.string = "\(currentDomain)/\(user?.userName.replacingOccurrences(of: " ", with: "") ?? "name")/\(user?.userId ?? "id")"
		self.isShowToastCopy = true
	}

	func statusAction() {
		isExpand.toggle()
	}

	func didSelectMenu(_ menu: MenuType) {
		switch menu {
		case .profile:
			isProfile.toggle()
		case .server:
			isSever.toggle()
		case .notification:
			isNotification.toggle()
		}

	}

	func didSelect(_ menu: MenuType) -> AnyView {
		switch menu {
		case .profile:
			return AnyView(NavigationLink(destination: ProfileView(),
										  isActive: $isProfile) {
				LinkButton(menu.title, icon: menu.icon, alignment: .leading) { didSelectMenu(menu) }
				.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight)
				.frame(height: Constants.itemHeight)
			})
		case .server:
			return AnyView(NavigationLink(destination: SettingServerView(),
										  isActive: $isSever) {
				LinkButton(menu.title, icon: menu.icon, alignment: .leading) { didSelectMenu(menu) }
				.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight)
				.frame(height: Constants.itemHeight)
			})
		case .notification:
			return AnyView(NavigationLink(destination: NotificationView(),
										  isActive: $isNotification) {
				LinkButton(menu.title, icon: menu.icon, alignment: .leading) { didSelectMenu(menu) }
				.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight)
				.frame(height: Constants.itemHeight)
			})
		}

	}

	func didSelectStatus(_ status: StatusType) {
		if self.user.first?.status == status {
			return
		}
		self.chageStatus(status)
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

	var backgroundColorMenu: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.darkgrey3
	}

	var opacityAction: Double {
		isExpand ? 1 : 0
	}
}
