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
	static let arrowSize = CGSize(width: 12.0, height: 12.0)
	static let statusSize = CGSize(width: 12.0, height: 12.0)
	static let statusOffset = UIOffset(horizontal: -20.0, vertical: 20.0)
	static let avatarSize = CGSize(width: 56.0, height: 56.0)
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
	let profile = DependencyResolver.shared.channelStorage.currentServer?.profile
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		GeometryReader { geometry in
			HStack {
				Spacer()
				VStack(alignment: .trailing) {
					ImageButton(AppTheme.shared.imageSet.closeIcon.renderingMode(.template)) { isShowMenu.toggle() }
						.foregroundColor(AppTheme.shared.colorSet.grey1)
					HStack {
                        if let avatar = user.first?.avatar,
                           !avatar.isEmpty {
                            ZStack {
                                Image(user.first?.avatar ?? "")
                                    .frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
                                    .clipShape(Circle())
                                    .foregroundColor(Color.gray)
                                Circle()
                                    .frame(width: Constants.statusSize.width, height: Constants.statusSize.height)
                                    .offset(x: Constants.statusOffset.vertical, y: Constants.statusOffset.horizontal)
                                    .foregroundColor(Color.green)
                            }
                        } else {
                            ZStack {
                                Circle()
                                    .fill(backgroundColor)
                                    .frame(width: Constants.avatarSize.width, height: Constants.avatarSize.height)
                                    .foregroundColor(Color.gray)
                                Text(user.first?.displayName.capitalized.prefix(1) ?? (profile?.userName ?? "Name").capitalized.prefix(1))
                                    .foregroundColor(AppTheme.shared.colorSet.offWhite)
                                    .font(AppTheme.shared.fontSet.font(style: .display3))
                            }
                        }
						
						VStack(alignment: .leading, spacing: Constants.spacing) {
							Text(user.first?.displayName ?? (profile?.userName ?? "Name"))
								.font(AppTheme.shared.fontSet.font(style: .body2))
								.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
								.frame(height: Constants.nameHeight)
							Menu {
                                ForEach([StatusType.online, StatusType.busy], id: \.self) { status in
									LinkButton(status.title, alignment: .leading, action: { self.didSelectStatus(status) })
										.foregroundColor(AppTheme.shared.colorSet.black)
										.frame(height: Constants.itemHeight)
								}
							} label: {
                                Text(self.user.first?.status.title ?? "")
									.font(AppTheme.shared.fontSet.font(style: .input3))
									.foregroundColor(self.user.first?.status.color ?? AppTheme.shared.colorSet.successDefault)
								AppTheme.shared.imageSet.chevDownIcon
									.renderingMode(.template)
									.aspectRatio(contentMode: .fit)
									.frame(width: Constants.arrowSize.width, height: Constants.arrowSize.height)
									.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight)
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
						.padding(.vertical, Constants.padding)
					ForEach(MenuType.allCases, id: \.self) { menu in
						LinkButton(menu.title, icon: menu.icon, alignment: .leading) { didSelectMenu(menu) }
							.foregroundColor(Color.gray)
							.frame(height: Constants.itemHeight)
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
			await injected.interactors.homeInteractor.signOut()
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
	
	func didSelectMenu(_ menu: MenuType) {
		
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
}
