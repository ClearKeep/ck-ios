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

protocol IAPIService {}

public class APIService {
	// MARK: - Variables
	public let domain: String!
	let header: HPACKHeaders!
	let group: MultiThreadedEventLoopGroup!
	let connection: ClientConnection!
	let clientAuth: Auth_AuthClient!
	let clientUser: User_UserClient!
	let clientGroup: Group_GroupClient!
	let clientMessage: Message_MessageClient!
	
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
	}
	
	deinit {
		try? group.syncShutdownGracefully()
	}
}

extension APIService: IAPIService {}
