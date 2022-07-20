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
import Model

protocol IAPIService {
	var callOptions: CallOptions { get set }
	var group: MultiThreadedEventLoopGroup { get }
	var connection: ClientConnection { get }
	var clientAuth: Auth_AuthClient { get }
	var clientUser: User_UserClient { get }
	var clientGroup: Group_GroupClient { get }
	var clientMessage: Message_MessageClient { get }
	var clientNotify: Notification_NotifyClient { get }
	var clientSignal: Signal_SignalKeyDistributionClient { get }
	var clientVideoCall: VideoCall_VideoCallClient { get }
	var clientNote: Note_NoteClient { get }
	var clientNotifyPush: NotifyPush_NotifyPushClient { get }
	var clientServerInfo: ServerInfo_ServerInfoClient { get }
	var clientUploadFile: UploadFile_UploadFileClient { get }
	var clientWorkspace: Workspace_WorkspaceClient { get }
	
	func updateHeaders(accessKey: String?, hashKey: String?)
}

public class APIService {
	// MARK: - Variables
	public let domain: String!
	public var owner: IUser?
	var callOptions: CallOptions
	let group: MultiThreadedEventLoopGroup
	let connection: ClientConnection
	let clientAuth: Auth_AuthClient
	let clientUser: User_UserClient
	let clientGroup: Group_GroupClient
	let clientMessage: Message_MessageClient
	let clientNotify: Notification_NotifyClient
	let clientSignal: Signal_SignalKeyDistributionClient
	let clientVideoCall: VideoCall_VideoCallClient
	let clientNote: Note_NoteClient
	let clientNotifyPush: NotifyPush_NotifyPushClient
	let clientServerInfo: ServerInfo_ServerInfoClient
	let clientUploadFile: UploadFile_UploadFileClient
	let clientWorkspace: Workspace_WorkspaceClient
	
	// MARK: - Init & Deinit
	public init(domain: String, owner: IUser?) {

		self.domain = domain
		callOptions = CallOptions()
		var headers: HPACKHeaders = ["domain": "localhost",
									 "ip_address": "0.0.0.0"]
		callOptions.customMetadata = headers
		
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
		clientNote = Note_NoteClient(channel: connection)
		clientNotifyPush = NotifyPush_NotifyPushClient(channel: connection)
		clientServerInfo = ServerInfo_ServerInfoClient(channel: connection)
		clientUploadFile = UploadFile_UploadFileClient(channel: connection)
		clientWorkspace = Workspace_WorkspaceClient(channel: connection)
		self.owner = owner
	}
	
	deinit {
		try? group.syncShutdownGracefully()
	}
}

extension APIService: IAPIService {
	public func updateHeaders(accessKey: String?, hashKey: String?) {
		if let accessKey = accessKey {
			callOptions.customMetadata.add(name: "access_token", value: accessKey)
		}
		
		if let hashKey = hashKey {
			callOptions.customMetadata.add(name: "hash_key", value: hashKey)
		}
	}
}
