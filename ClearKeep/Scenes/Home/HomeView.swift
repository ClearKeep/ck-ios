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
import Networking

private enum Constants {
	static let padding = 20.0
	static let paddingTop = 49.0
	static let opacity = 0.72
	static let blur = 10.0
	static let duration = 0.2
	static let spacing = 18.0
	static let paddingMenu = 34.0
}

struct HomeView: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.joinServerClosure) private var joinServerClosure: JoinServerClosure
	@State private var selectedRoomId: Int64 = 0
	@State private var selectedNotiDomain: String = ""
	@State private var showMessageBanner: Bool = false
	@State private var messageData: MessagerBannerViewModifier.MessageData?
	@State private(set) var isExpandGroup: Bool = false
	@State private(set) var isExpandDirectMessage: Bool = false
	@State private var isFirstShowGroup: Bool = false
	@State private var isFirstShowPeer: Bool = false
	@State private var navigateToChat: Bool = false
	@State private var navigateToLogin: Bool = false
	@State private(set) var customServer: CustomServer = CustomServer()
	@State private(set) var serverURL: String = ""
	@State private(set) var loadable: Loadable<HomeViewModels> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let load):
				isLoading = false
				let groups = load.groupViewModel?.viewModelGroup.filter { $0.groupType == "group" && $0.groupMembers.contains(where: { $0.userId == DependencyResolver.shared.channelStorage.currentServer?.profile?.userId && $0.userState != "leaved" }) }.sorted(by: { $0.updatedAt > $1.updatedAt }).compactMap { profile in
									GroupViewModel(profile)} ?? []
				print("groups", groups)
				let peers = load.groupViewModel?.viewModelGroup.filter { $0.groupType != "group" }.sorted(by: { $0.updatedAt > $1.updatedAt }).compactMap { profile in
					GroupViewModel(profile)} ?? []
				if !groups.isEmpty && !isFirstShowGroup {
					isFirstShowGroup = true
					isExpandGroup = true
				}
				
				if !peers.isEmpty && !isFirstShowPeer {
					isFirstShowPeer = true
					isExpandDirectMessage = true
				}
				
				self.groups = groups
				self.peers = peers
				self.user = [UserViewModel(load.userViewModel?.viewModelUser)]
			case .failed(let error):
				isLoading = false
				let error = HomeErrorView(error)
				switch error {
				case .unauthorized:
					self.handleLogout()
				default:
					self.error = error
					self.isShowError = true
				}
				
			case .isLoading:
				isLoading = true
			default: break
			}
		}
	}
	
	@State private var loadableStatus: Loadable<UserViewModels> = .notRequested {
		didSet {
			switch loadableStatus {
			case .loaded(let load):
				isLoading = false
				self.user = [UserViewModel(load.viewModelUser)]
			case .failed(let error):
				isLoading = false
				self.error = HomeErrorView(error)
				self.isShowError = true
			case .isLoading:
				isLoading = true
			default: break
			}
		}
	}
	
	@State private(set) var loadableUrl: Loadable<Bool> = .notRequested {
		didSet {
			switch loadableUrl {
			case .loaded:
				isLoading = false
				customServer.customServerURL = serverURL
				customServer.isSelectedCustomServer = true
				navigateToLogin = true
			case .failed(let error):
				isLoading = false
				self.error = HomeErrorView(error)
				self.isShowError = true
			case .isLoading:
				isLoading = true
			default: break
			}
		}
	}
	@StateObject var callViewModel: CallViewModel = CallViewModel()
	
	@State private(set) var servers: [ServerViewModel] = []
	@State private(set) var searchKeyword: String = ""
	@State private(set) var searchInputStyle: TextInputStyle = .default
	@State private(set) var isShowMenu: Bool = false
	@State private(set) var isAddNewServer: Bool = false
	@State private(set) var groups: [GroupViewModel] = []
	@State private(set) var peers: [GroupViewModel] = []
	@State private(set) var user: [UserViewModel] = [UserViewModel]()
	@State private var isLoading: Bool = false
	@State private var isShowError: Bool = false
	@State private var error: HomeErrorView?
	@State private var isInCall = false
	@AppStorage("preview") private var isPreviewBanner: Bool?
	let inspection = ViewInspector<Self>()
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			GeometryReader { geometry in
				ZStack {
					HStack {
						ListServerView(servers: $servers, isAddNewServer: $isAddNewServer, action: getServerInfo)
						VStack(spacing: Constants.spacing) {
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
					.padding(.top, Constants.paddingTop)
					.hideKeyboardOnTapped()
					NavigationLink(destination: ChatView(inputStyle: .default, groupId: DependencyResolver.shared.messageService.currentRoomId, avatarLink: ""), isActive: $navigateToChat) {
						EmptyView()
					}
					NavigationLink(
						destination: LoginView(customServer: customServer, navigateToHome: navigateToLogin, rootIsActive: $navigateToLogin),
						isActive: $navigateToLogin,
						label: {
						})
				}
				.progressHUD(isLoading)
				.hiddenNavigationBarStyle()
				
				if isShowMenu {
					LinearGradient(gradient: Gradient(colors: colorScheme == .light ? AppTheme.shared.colorSet.gradientPrimary.compactMap({ $0.opacity(Constants.opacity) }) : AppTheme.shared.colorSet.gradientBlack.compactMap({ $0.opacity(Constants.opacity) })), startPoint: .leading, endPoint: .trailing)
						.blur(radius: Constants.blur)
						.edgesIgnoringSafeArea(.vertical)
					MenuView(isShowMenu: $isShowMenu,
							 user: $user,
							 chageStatus: { status in
						self.changeStatus(status: status)
					}, servers: $servers)
						.frame(width: geometry.size.width)
						.offset(x: isShowMenu ? 0 : geometry.size.width * 2)
						.transition(.move(edge: .trailing))
						.animation(.default, value: Constants.duration)
						.ignoresSafeArea()
						.padding(.top, Constants.paddingMenu)
				}
			}
			.onAppear(perform: getServers)
			.onAppear(perform: getServerInfo)
			.onReceive(NotificationCenter.default.publisher(for: NSNotification.reloadDataHome, object: nil), perform: { _ in
				self.isShowMenu = false
				self.serverInfo()
				self.getServers()
			})
			.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.SubscribeAndListenService.didReceiveNotification), perform: { (obj) in
				if let userInfo = obj.userInfo,
				   let publication = userInfo["notification"] as? Notification_NotifyObjectResponse {
					if publication.notifyType == "new-peer" || publication.notifyType == "new-group" {
						getServerInfo()
					}
				}
			})
			.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.SubscribeAndListenService.didReceiveMessage)) { (obj) in
				print("received message banner...... \(obj)")
				if let userInfo = obj.userInfo,
				   let ownerDomain = userInfo["domain"] as? String,
				   let message = userInfo["message"] as? IMessageModel {
					if message.groupType == "group" {
						let groupName = injected.interactors.homeInteractor.getGroupName(groupID: message.groupId)
						let senderName = injected.interactors.homeInteractor.getSenderName(fromClientId: message.senderId, groupID: message.groupId)
						if isPreviewBanner ?? true {
							self.messageData = MessagerBannerViewModifier.MessageData(groupName: groupName, senderName: senderName, message: message.message)
						} else {
							self.messageData = MessagerBannerViewModifier.MessageData(groupName: groupName, senderName: senderName, message: "General.Message.Banner.Preview".localized)
						}
					} else {
						let senderName = injected.interactors.homeInteractor.getSenderName(fromClientId: message.senderId, groupID: message.groupId)
						if isPreviewBanner ?? true {
							self.messageData = MessagerBannerViewModifier.MessageData(senderName: senderName, message: message.message)
						} else {
							self.messageData = MessagerBannerViewModifier.MessageData(senderName: senderName, message: "General.Message.Banner.Preview".localized)
						}
					}
					if DependencyResolver.shared.messageService.currentRoomId != message.groupId {
						selectedRoomId = message.groupId
						self.selectedNotiDomain = ownerDomain
						self.showMessageBanner = true
					}
				}
			}
		}
		.hiddenNavigationBarStyle()
		.alert(isPresented: $isShowError) {
			Alert(title: Text(self.error?.title ?? ""),
				  message: Text(self.error?.message ?? ""),
				  dismissButton: .default(Text(error?.primaryButtonTitle ?? "")))
		}
		.messagerBannerModifier(data: $messageData, show: $showMessageBanner, onTap: {
			servers = injected.interactors.homeInteractor.didSelectServer(selectedNotiDomain)
			DependencyResolver.shared.messageService.updateCurrentRoom(roomId: selectedRoomId)
			navigateToChat = true
		})
		.inCallModifier(callViewModel: callViewModel, isInCall: $isInCall)
		.environment(\.joinServerClosure, { domain in
			self.injected.interactors.homeInteractor.didSelectServer(domain)
			self.isAddNewServer = false
		})
		.onReceive(inspection.notice) { self.inspection.visit(self, $0) }
		.onDisappear {
			self.serverURL = ""
		}
	}
}

// MARK: - Private
private extension HomeView {
	var content: AnyView {
		if isAddNewServer {
			return AnyView(JoinServerView(serverURL: $serverURL, checkUrl: { urlString in
				servers.forEach { server in
					if urlString == server.serverDomain {
						self.error = .domainUsed
						self.isShowError = true
					} else {
						serverURL = urlString
						loadableUrl = .isLoading(last: nil, cancelBag: CancelBag())
						Task {
							loadableUrl = await injected.interactors.homeInteractor.workspaceInfo(workspaceDomain: urlString)
						}
					}
				}
			}))
		} else {
			return AnyView(HomeContentView(groups: $groups, peers: $peers, serverName: .constant(serverName), isExpandGroup: $isExpandGroup, isExpandDirectMessage: $isExpandDirectMessage))
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

// MARK: - Interactors
private extension HomeView {
	func getServers() {
		servers = injected.interactors.homeInteractor.getServers()
	}
	
	func getServerInfo() {
		self.loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.homeInteractor.getServerInfo()
		}
	}
	
	func serverInfo() {
		self.loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.homeInteractor.getServerInfo()
		}
	}
	
	func changeStatus(status: StatusType) {
		self.loadableStatus = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadableStatus = await injected.interactors.homeInteractor.updateStatus(status: status.rawValue)
		}
	}
	
	func handleLogout() {
		injected.interactors.homeInteractor.removeServer()
		let servers = DependencyResolver.shared.channelStorage.getServers(isFirstLoad: false).compactMap({
			ServerModel($0)
		})
		
		if servers.isEmpty {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
				let appDelegate = UIApplication.shared.delegate as? AppDelegate
				appDelegate?.systemEventsHandler?.container.appState[\.authentication.servers] = []
			})
			return
		}
		
		if servers.filter({ $0.isActive }).isEmpty {
			DependencyResolver.shared.channelStorage.didSelectServer(servers.last?.serverDomain ?? "")
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
			self.isShowMenu = false
			self.serverInfo()
			self.getServers()
		})
	}
}

// MARK: - extension
extension NSNotification {
	static let reloadDataHome = Notification.Name.init("reloadDataHome")
}

// MARK: - Preview
#if DEBUG
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
#endif
