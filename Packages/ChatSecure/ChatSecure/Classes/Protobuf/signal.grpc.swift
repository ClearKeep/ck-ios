//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: signal.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Usage: instantiate `Signal_SignalKeyDistributionClient`, then call methods of this protocol to make API calls.
internal protocol Signal_SignalKeyDistributionClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Signal_SignalKeyDistributionClientInterceptorFactoryProtocol? { get }

  func peerRegisterClientKey(
    _ request: Signal_PeerRegisterClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse>

  func peerGetClientKey(
    _ request: Signal_PeerGetClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_PeerGetClientKeyRequest, Signal_PeerGetClientKeyResponse>

  func clientUpdatePeerKey(
    _ request: Signal_PeerRegisterClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse>

  func groupRegisterClientKey(
    _ request: Signal_GroupRegisterClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_GroupRegisterClientKeyRequest, Signal_BaseResponse>

  func groupUpdateClientKey(
    _ request: Signal_GroupUpdateClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_GroupUpdateClientKeyRequest, Signal_BaseResponse>

  func groupGetClientKey(
    _ request: Signal_GroupGetClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_GroupGetClientKeyRequest, Signal_GroupGetClientKeyResponse>

  func groupGetAllClientKey(
    _ request: Signal_GroupGetAllClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_GroupGetAllClientKeyRequest, Signal_GroupGetAllClientKeyResponse>

  func workspaceGroupGetClientKey(
    _ request: Signal_WorkspaceGroupGetClientKeyRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Signal_WorkspaceGroupGetClientKeyRequest, Signal_WorkspaceGroupGetClientKeyResponse>
}

extension Signal_SignalKeyDistributionClientProtocol {
  internal var serviceName: String {
    return "signal.SignalKeyDistribution"
  }

  ///peer
  ///
  /// - Parameters:
  ///   - request: Request to send to PeerRegisterClientKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func peerRegisterClientKey(
    _ request: Signal_PeerRegisterClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/PeerRegisterClientKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePeerRegisterClientKeyInterceptors() ?? []
    )
  }

  /// Unary call to PeerGetClientKey
  ///
  /// - Parameters:
  ///   - request: Request to send to PeerGetClientKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func peerGetClientKey(
    _ request: Signal_PeerGetClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_PeerGetClientKeyRequest, Signal_PeerGetClientKeyResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/PeerGetClientKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePeerGetClientKeyInterceptors() ?? []
    )
  }

  /// Unary call to ClientUpdatePeerKey
  ///
  /// - Parameters:
  ///   - request: Request to send to ClientUpdatePeerKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func clientUpdatePeerKey(
    _ request: Signal_PeerRegisterClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/ClientUpdatePeerKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeClientUpdatePeerKeyInterceptors() ?? []
    )
  }

  ///group
  ///
  /// - Parameters:
  ///   - request: Request to send to GroupRegisterClientKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func groupRegisterClientKey(
    _ request: Signal_GroupRegisterClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_GroupRegisterClientKeyRequest, Signal_BaseResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/GroupRegisterClientKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGroupRegisterClientKeyInterceptors() ?? []
    )
  }

  /// Unary call to GroupUpdateClientKey
  ///
  /// - Parameters:
  ///   - request: Request to send to GroupUpdateClientKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func groupUpdateClientKey(
    _ request: Signal_GroupUpdateClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_GroupUpdateClientKeyRequest, Signal_BaseResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/GroupUpdateClientKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGroupUpdateClientKeyInterceptors() ?? []
    )
  }

  /// Unary call to GroupGetClientKey
  ///
  /// - Parameters:
  ///   - request: Request to send to GroupGetClientKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func groupGetClientKey(
    _ request: Signal_GroupGetClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_GroupGetClientKeyRequest, Signal_GroupGetClientKeyResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/GroupGetClientKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGroupGetClientKeyInterceptors() ?? []
    )
  }

  /// Unary call to GroupGetAllClientKey
  ///
  /// - Parameters:
  ///   - request: Request to send to GroupGetAllClientKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func groupGetAllClientKey(
    _ request: Signal_GroupGetAllClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_GroupGetAllClientKeyRequest, Signal_GroupGetAllClientKeyResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/GroupGetAllClientKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGroupGetAllClientKeyInterceptors() ?? []
    )
  }

  ///workspace
  ///
  /// - Parameters:
  ///   - request: Request to send to WorkspaceGroupGetClientKey.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func workspaceGroupGetClientKey(
    _ request: Signal_WorkspaceGroupGetClientKeyRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Signal_WorkspaceGroupGetClientKeyRequest, Signal_WorkspaceGroupGetClientKeyResponse> {
    return self.makeUnaryCall(
      path: "/signal.SignalKeyDistribution/WorkspaceGroupGetClientKey",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeWorkspaceGroupGetClientKeyInterceptors() ?? []
    )
  }
}

internal protocol Signal_SignalKeyDistributionClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'peerRegisterClientKey'.
  func makePeerRegisterClientKeyInterceptors() -> [ClientInterceptor<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when invoking 'peerGetClientKey'.
  func makePeerGetClientKeyInterceptors() -> [ClientInterceptor<Signal_PeerGetClientKeyRequest, Signal_PeerGetClientKeyResponse>]

  /// - Returns: Interceptors to use when invoking 'clientUpdatePeerKey'.
  func makeClientUpdatePeerKeyInterceptors() -> [ClientInterceptor<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when invoking 'groupRegisterClientKey'.
  func makeGroupRegisterClientKeyInterceptors() -> [ClientInterceptor<Signal_GroupRegisterClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when invoking 'groupUpdateClientKey'.
  func makeGroupUpdateClientKeyInterceptors() -> [ClientInterceptor<Signal_GroupUpdateClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when invoking 'groupGetClientKey'.
  func makeGroupGetClientKeyInterceptors() -> [ClientInterceptor<Signal_GroupGetClientKeyRequest, Signal_GroupGetClientKeyResponse>]

  /// - Returns: Interceptors to use when invoking 'groupGetAllClientKey'.
  func makeGroupGetAllClientKeyInterceptors() -> [ClientInterceptor<Signal_GroupGetAllClientKeyRequest, Signal_GroupGetAllClientKeyResponse>]

  /// - Returns: Interceptors to use when invoking 'workspaceGroupGetClientKey'.
  func makeWorkspaceGroupGetClientKeyInterceptors() -> [ClientInterceptor<Signal_WorkspaceGroupGetClientKeyRequest, Signal_WorkspaceGroupGetClientKeyResponse>]
}

internal final class Signal_SignalKeyDistributionClient: Signal_SignalKeyDistributionClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Signal_SignalKeyDistributionClientInterceptorFactoryProtocol?

  /// Creates a client for the signal.SignalKeyDistribution service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Signal_SignalKeyDistributionClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol Signal_SignalKeyDistributionProvider: CallHandlerProvider {
  var interceptors: Signal_SignalKeyDistributionServerInterceptorFactoryProtocol? { get }

  ///peer
  func peerRegisterClientKey(request: Signal_PeerRegisterClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_BaseResponse>

  func peerGetClientKey(request: Signal_PeerGetClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_PeerGetClientKeyResponse>

  func clientUpdatePeerKey(request: Signal_PeerRegisterClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_BaseResponse>

  ///group
  func groupRegisterClientKey(request: Signal_GroupRegisterClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_BaseResponse>

  func groupUpdateClientKey(request: Signal_GroupUpdateClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_BaseResponse>

  func groupGetClientKey(request: Signal_GroupGetClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_GroupGetClientKeyResponse>

  func groupGetAllClientKey(request: Signal_GroupGetAllClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_GroupGetAllClientKeyResponse>

  ///workspace
  func workspaceGroupGetClientKey(request: Signal_WorkspaceGroupGetClientKeyRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Signal_WorkspaceGroupGetClientKeyResponse>
}

extension Signal_SignalKeyDistributionProvider {
  internal var serviceName: Substring { return "signal.SignalKeyDistribution" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "PeerRegisterClientKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_PeerRegisterClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_BaseResponse>(),
        interceptors: self.interceptors?.makePeerRegisterClientKeyInterceptors() ?? [],
        userFunction: self.peerRegisterClientKey(request:context:)
      )

    case "PeerGetClientKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_PeerGetClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_PeerGetClientKeyResponse>(),
        interceptors: self.interceptors?.makePeerGetClientKeyInterceptors() ?? [],
        userFunction: self.peerGetClientKey(request:context:)
      )

    case "ClientUpdatePeerKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_PeerRegisterClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_BaseResponse>(),
        interceptors: self.interceptors?.makeClientUpdatePeerKeyInterceptors() ?? [],
        userFunction: self.clientUpdatePeerKey(request:context:)
      )

    case "GroupRegisterClientKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_GroupRegisterClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_BaseResponse>(),
        interceptors: self.interceptors?.makeGroupRegisterClientKeyInterceptors() ?? [],
        userFunction: self.groupRegisterClientKey(request:context:)
      )

    case "GroupUpdateClientKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_GroupUpdateClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_BaseResponse>(),
        interceptors: self.interceptors?.makeGroupUpdateClientKeyInterceptors() ?? [],
        userFunction: self.groupUpdateClientKey(request:context:)
      )

    case "GroupGetClientKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_GroupGetClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_GroupGetClientKeyResponse>(),
        interceptors: self.interceptors?.makeGroupGetClientKeyInterceptors() ?? [],
        userFunction: self.groupGetClientKey(request:context:)
      )

    case "GroupGetAllClientKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_GroupGetAllClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_GroupGetAllClientKeyResponse>(),
        interceptors: self.interceptors?.makeGroupGetAllClientKeyInterceptors() ?? [],
        userFunction: self.groupGetAllClientKey(request:context:)
      )

    case "WorkspaceGroupGetClientKey":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Signal_WorkspaceGroupGetClientKeyRequest>(),
        responseSerializer: ProtobufSerializer<Signal_WorkspaceGroupGetClientKeyResponse>(),
        interceptors: self.interceptors?.makeWorkspaceGroupGetClientKeyInterceptors() ?? [],
        userFunction: self.workspaceGroupGetClientKey(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Signal_SignalKeyDistributionServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'peerRegisterClientKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makePeerRegisterClientKeyInterceptors() -> [ServerInterceptor<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when handling 'peerGetClientKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makePeerGetClientKeyInterceptors() -> [ServerInterceptor<Signal_PeerGetClientKeyRequest, Signal_PeerGetClientKeyResponse>]

  /// - Returns: Interceptors to use when handling 'clientUpdatePeerKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeClientUpdatePeerKeyInterceptors() -> [ServerInterceptor<Signal_PeerRegisterClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when handling 'groupRegisterClientKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGroupRegisterClientKeyInterceptors() -> [ServerInterceptor<Signal_GroupRegisterClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when handling 'groupUpdateClientKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGroupUpdateClientKeyInterceptors() -> [ServerInterceptor<Signal_GroupUpdateClientKeyRequest, Signal_BaseResponse>]

  /// - Returns: Interceptors to use when handling 'groupGetClientKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGroupGetClientKeyInterceptors() -> [ServerInterceptor<Signal_GroupGetClientKeyRequest, Signal_GroupGetClientKeyResponse>]

  /// - Returns: Interceptors to use when handling 'groupGetAllClientKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGroupGetAllClientKeyInterceptors() -> [ServerInterceptor<Signal_GroupGetAllClientKeyRequest, Signal_GroupGetAllClientKeyResponse>]

  /// - Returns: Interceptors to use when handling 'workspaceGroupGetClientKey'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeWorkspaceGroupGetClientKeyInterceptors() -> [ServerInterceptor<Signal_WorkspaceGroupGetClientKeyRequest, Signal_WorkspaceGroupGetClientKeyResponse>]
}
