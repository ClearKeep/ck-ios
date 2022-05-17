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

private enum Constants {
	static let padding = 20.0
	static let cornerRadius = 16.0
	static let opacity = 0.72
	static let blur = 10.0
	static let duration = 0.2
	static let hSpacing = 28.0
	static let searchHeight = 52.0
}

struct HomeView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var loadable: Loadable<[GroupViewModel]> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let groups):
				self.groups = groups.filter({ $0.groupType == "group" })
				self.peers = groups.filter({ $0.groupType == "peer" })
			default: break
			}
		}
	}
	@State private(set) var searchKeyword: String = ""
	@State private(set) var searchInputStyle: TextInputStyle = .default
	@State private(set) var isShowMenu: Bool = false
	@State private(set) var isAddNewServer: Bool = false
	@State private(set) var servers: [ServerViewModel] = []
	@State private(set) var selectedServer: ServerViewModel? {
		didSet {
			getScreenInfo()
		}
	}
	@State private(set) var groups: [GroupViewModel] = []
	@State private(set) var peers: [GroupViewModel] = []
	
	let inspection = ViewInspector<Self>()
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				HStack {
					ListServerView(servers: $servers, selectedServer: $selectedServer)
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
						Group {
							if selectedServer == nil {
								JoinServerView()
							} else {
								VStack {
									Button(action: searchAction, label: {
										HStack(spacing: Constants.hSpacing) {
											AppTheme.shared.imageSet.searchIcon
												.foregroundColor(AppTheme.shared.colorSet.greyLight)
											Text("Home.Search".localized)
												.font(AppTheme.shared.fontSet.font(style: .input3))
												.foregroundColor(AppTheme.shared.colorSet.greyLight)
										}
										.padding()
										.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
									})
									.frame(height: Constants.searchHeight)
									.background(colorScheme == .light ? AppTheme.shared.colorSet.grey5 : AppTheme.shared.colorSet.darkgrey3)
									.cornerRadius(Constants.cornerRadius)
									ScrollView {
										ListGroupView(title: "Home.GroupChat".localized, groups: groups, action: { print("Group") })
										ListGroupView(title: "Home.DirectMessages".localized, groups: peers, action: { print("Peer") })
									}
								}
							}
						}
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
				MenuView(isShowMenu: $isShowMenu)
					.frame(width: geometry.size.width)
					.offset(x: isShowMenu ? 0 : geometry.size.width * 2)
					.transition(.move(edge: .trailing))
					.animation(.default, value: Constants.duration)
			}
		}
		.onAppear(perform: getServers)
		.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension HomeView {
}

// MARK: -
private extension HomeView {
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var serverName: String {
		if let selectedServer = selectedServer {
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
		selectedServer = servers.first
	}
	
	func getScreenInfo() {
		Task {
			loadable = await injected.interactors.homeInteractor.getJoinedGroup()
		}
	}
}

// MARK: - Action
private extension HomeView {
	func searchAction() {
		
	}
}

// MARK: - Preview
#if DEBUG
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
#endif
