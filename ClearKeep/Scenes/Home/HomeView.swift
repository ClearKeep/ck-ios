//
//  HomeView.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI
import Model

private enum Constants {
	static let padding = 20.0
	static let opacity = 0.72
	static let blur = 10.0
	static let duration = 0.2
}

struct HomeView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var loadable: Loadable<HomeViewModels> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let load):
				self.groups = load.groupViewModel?.viewModelGroup.compactMap { profile in
					GroupViewModel(profile)} ?? [GroupViewModel]()
				self.peers = load.groupViewModel?.viewModelGroup.compactMap { profile in
					GroupViewModel(profile)} ?? [GroupViewModel]()
				self.user = [load.userViewModel?.viewModelUser].compactMap { profile in
					UserViewModel(profile)}
			case .failed(let error):
				print(error)
			default: break
			}
		}
	}
	
	@State private(set) var servers: [ServerViewModel] = []
	@State private(set) var searchKeyword: String = ""
	@State private(set) var searchInputStyle: TextInputStyle = .default
	@State private(set) var isShowMenu: Bool = false
	@State private(set) var isAddNewServer: Bool = false
	@State private(set) var groups: [GroupViewModel] = []
	@State private(set) var peers: [GroupViewModel] = []
	@State private(set) var user: [UserViewModel] = [UserViewModel]()
	let inspection = ViewInspector<Self>()

	var body: some View {
		GeometryReader { geometry in
			ZStack {
				HStack {
					ListServerView(servers: $servers, isAddNewServer: $isAddNewServer, action: getServerInfo)
					VStack {
						HStack {
							Text(serverName)
								.font(AppTheme.shared.fontSet.font(style: .display3))
								.foregroundColor(titleColor)
							Spacer()
							ImageButton(AppTheme.shared.imageSet.menuIcon) {
								withAnimation {
									isShowMenu.toggle()
								}
							}
							.foregroundColor(titleColor)
						}
						content
							.padding(.top, Constants.padding)
					}
					.padding(Constants.padding)
				}
				.padding(.top, Constants.padding)
				.hideKeyboardOnTapped()
			}
			
			if isShowMenu {
				LinearGradient(gradient: Gradient(colors: colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary.compactMap({ $0.opacity(Constants.opacity) }) : AppTheme.shared.colorSet.gradientBlack), startPoint: .leading, endPoint: .trailing)
					.blur(radius: Constants.blur)
					.edgesIgnoringSafeArea(.vertical)
				MenuView(isShowMenu: $isShowMenu, user: $user)
					.frame(width: geometry.size.width)
					.offset(x: isShowMenu ? 0 : geometry.size.width * 2)
					.transition(.move(edge: .trailing))
					.animation(.default, value: Constants.duration)
			}
		}
		.onAppear(perform: getServers)
		.onAppear(perform: getUser)
		.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension HomeView {
	var content: AnyView {
		if isAddNewServer {
			return AnyView(JoinServerView())
		} else {
			return AnyView(HomeContentView(groups: $groups, peers: $peers))
		}
	}
	
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var serverName: String {
		if let selectedServer = servers.filter({ $0.isActive == true }).first, !isAddNewServer {
			return selectedServer.serverName
		} else {
			return "JoinServer.Title".localized
		}
	}
}

// MARK: - Loading Content
private extension HomeView {
}

// MARK: - Displaying Content
private extension HomeView {
}

// MARK: - Interactors
private extension HomeView {
	func getServers() {
		servers = injected.interactors.homeInteractor.getServers()
	}

	func getUser() {
		Task {
			loadable = await injected.interactors.homeInteractor.getProfile()
		}
	}

	func getServerInfo() {
		Task {
			loadable = await injected.interactors.homeInteractor.getJoinedGroup()
		}
	}
}

// MARK: - Action
private extension HomeView {
}

// MARK: - Preview
#if DEBUG
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
#endif
