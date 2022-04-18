//
//  IAPIService.swift
//  
//
//  Created by NamNH on 21/02/2022.
//

import Foundation
import NIOPosix
import NIOHPACK
import GRPC

protocol IAPIService {
	var header: HPACKHeaders { get }
	var group: MultiThreadedEventLoopGroup { get }
	var connection: ClientConnection { get }
	var clientAuth: Auth_AuthClient { get }
	var clientUser: User_UserClient { get }
	var clientGroup: Group_GroupClient { get }
	var clientMessage: Message_MessageClient { get }
	var clientNotify: Notification_NotifyClient { get }
	var clientSignal: Signal_SignalKeyDistributionClient { get }
}

public class APIService {
	// MARK: - Variables
	public let domain: String!
	public var owner: IUser?
	let header: HPACKHeaders
	let group: MultiThreadedEventLoopGroup
	let connection: ClientConnection
	let clientAuth: Auth_AuthClient
	let clientUser: User_UserClient
	let clientGroup: Group_GroupClient
	let clientMessage: Message_MessageClient
	let clientNotify: Notification_NotifyClient
	let clientSignal: Signal_SignalKeyDistributionClient
	let clientVideoCall: VideoCall_VideoCallClient
	
	// MARK: - Init & Deinit
	public init(domain: String) {
		self.domain = domain
		header = HPACKHeaders()
		group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
		
		let domainConfig = domain.components(separatedBy: ":")
		let configuration = ClientConnection.Configuration.default(target: .hostAndPort(domainConfig.first ?? "", Int(domainConfig.last ?? "") ?? 443), eventLoopGroup: group)
		
		connection = ClientConnection(configuration: configuration)
		
		clientAuth = Auth_AuthClient(channel: connection)
		clientUser = User_UserClient(channel: connection)
		clientGroup = Group_GroupClient(channel: connection)
		clientMessage = Message_MessageClient(channel: connection)
		clientNotify = Notification_NotifyClient(channel: connection)
		clientSignal = Signal_SignalKeyDistributionClient(channel: connection)
		clientVideoCall = VideoCall_VideoCallClient(channel: connection)
	}
	
	deinit {
		try? group.syncShutdownGracefully()
	}
}

extension APIService: IAPIService {}
