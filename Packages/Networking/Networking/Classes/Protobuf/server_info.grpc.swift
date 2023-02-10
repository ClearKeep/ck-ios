//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: server_info.proto
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
import NIOConcurrencyHelpers
import SwiftProtobuf


/// Usage: instantiate `ServerInfo_ServerInfoClient`, then call methods of this protocol to make API calls.
internal protocol ServerInfo_ServerInfoClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol? { get }

  func update_nts(
    _ request: ServerInfo_UpdateNTSReq,
    callOptions: CallOptions?
  ) -> UnaryCall<ServerInfo_UpdateNTSReq, ServerInfo_BaseResponse>

  func total_thread(
    _ request: ServerInfo_Empty,
    callOptions: CallOptions?
  ) -> UnaryCall<ServerInfo_Empty, ServerInfo_GetThreadResponse>
}

extension ServerInfo_ServerInfoClientProtocol {
  internal var serviceName: String {
    return "server_info.ServerInfo"
  }

  /// Unary call to update_nts
  ///
  /// - Parameters:
  ///   - request: Request to send to update_nts.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func update_nts(
    _ request: ServerInfo_UpdateNTSReq,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<ServerInfo_UpdateNTSReq, ServerInfo_BaseResponse> {
    return self.makeUnaryCall(
      path: ServerInfo_ServerInfoClientMetadata.Methods.update_nts.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeupdate_ntsInterceptors() ?? []
    )
  }

  /// Unary call to total_thread
  ///
  /// - Parameters:
  ///   - request: Request to send to total_thread.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func total_thread(
    _ request: ServerInfo_Empty,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<ServerInfo_Empty, ServerInfo_GetThreadResponse> {
    return self.makeUnaryCall(
      path: ServerInfo_ServerInfoClientMetadata.Methods.total_thread.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.maketotal_threadInterceptors() ?? []
    )
  }
}

#if compiler(>=5.6)
@available(*, deprecated)
extension ServerInfo_ServerInfoClient: @unchecked Sendable {}
#endif // compiler(>=5.6)

@available(*, deprecated, renamed: "ServerInfo_ServerInfoNIOClient")
internal final class ServerInfo_ServerInfoClient: ServerInfo_ServerInfoClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol?
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  internal var interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the server_info.ServerInfo service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

internal struct ServerInfo_ServerInfoNIOClient: ServerInfo_ServerInfoClientProtocol {
  internal var channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol?

  /// Creates a client for the server_info.ServerInfo service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

#if compiler(>=5.6)
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal protocol ServerInfo_ServerInfoAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol? { get }

  func makeUpdateNtsCall(
    _ request: ServerInfo_UpdateNTSReq,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<ServerInfo_UpdateNTSReq, ServerInfo_BaseResponse>

  func makeTotalThreadCall(
    _ request: ServerInfo_Empty,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<ServerInfo_Empty, ServerInfo_GetThreadResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension ServerInfo_ServerInfoAsyncClientProtocol {
  internal static var serviceDescriptor: GRPCServiceDescriptor {
    return ServerInfo_ServerInfoClientMetadata.serviceDescriptor
  }

  internal var interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol? {
    return nil
  }

  internal func makeUpdateNtsCall(
    _ request: ServerInfo_UpdateNTSReq,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<ServerInfo_UpdateNTSReq, ServerInfo_BaseResponse> {
    return self.makeAsyncUnaryCall(
      path: ServerInfo_ServerInfoClientMetadata.Methods.update_nts.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeupdate_ntsInterceptors() ?? []
    )
  }

  internal func makeTotalThreadCall(
    _ request: ServerInfo_Empty,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<ServerInfo_Empty, ServerInfo_GetThreadResponse> {
    return self.makeAsyncUnaryCall(
      path: ServerInfo_ServerInfoClientMetadata.Methods.total_thread.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.maketotal_threadInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension ServerInfo_ServerInfoAsyncClientProtocol {
  internal func update_nts(
    _ request: ServerInfo_UpdateNTSReq,
    callOptions: CallOptions? = nil
  ) async throws -> ServerInfo_BaseResponse {
    return try await self.performAsyncUnaryCall(
      path: ServerInfo_ServerInfoClientMetadata.Methods.update_nts.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeupdate_ntsInterceptors() ?? []
    )
  }

  internal func total_thread(
    _ request: ServerInfo_Empty,
    callOptions: CallOptions? = nil
  ) async throws -> ServerInfo_GetThreadResponse {
    return try await self.performAsyncUnaryCall(
      path: ServerInfo_ServerInfoClientMetadata.Methods.total_thread.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.maketotal_threadInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal struct ServerInfo_ServerInfoAsyncClient: ServerInfo_ServerInfoAsyncClientProtocol {
  internal var channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol?

  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: ServerInfo_ServerInfoClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

#endif // compiler(>=5.6)

internal protocol ServerInfo_ServerInfoClientInterceptorFactoryProtocol: GRPCSendable {

  /// - Returns: Interceptors to use when invoking 'update_nts'.
  func makeupdate_ntsInterceptors() -> [ClientInterceptor<ServerInfo_UpdateNTSReq, ServerInfo_BaseResponse>]

  /// - Returns: Interceptors to use when invoking 'total_thread'.
  func maketotal_threadInterceptors() -> [ClientInterceptor<ServerInfo_Empty, ServerInfo_GetThreadResponse>]
}

internal enum ServerInfo_ServerInfoClientMetadata {
  internal static let serviceDescriptor = GRPCServiceDescriptor(
    name: "ServerInfo",
    fullName: "server_info.ServerInfo",
    methods: [
      ServerInfo_ServerInfoClientMetadata.Methods.update_nts,
      ServerInfo_ServerInfoClientMetadata.Methods.total_thread,
    ]
  )

  internal enum Methods {
    internal static let update_nts = GRPCMethodDescriptor(
      name: "update_nts",
      path: "/server_info.ServerInfo/update_nts",
      type: GRPCCallType.unary
    )

    internal static let total_thread = GRPCMethodDescriptor(
      name: "total_thread",
      path: "/server_info.ServerInfo/total_thread",
      type: GRPCCallType.unary
    )
  }
}

/// To build a server, implement a class that conforms to this protocol.
internal protocol ServerInfo_ServerInfoProvider: CallHandlerProvider {
  var interceptors: ServerInfo_ServerInfoServerInterceptorFactoryProtocol? { get }

  func update_nts(request: ServerInfo_UpdateNTSReq, context: StatusOnlyCallContext) -> EventLoopFuture<ServerInfo_BaseResponse>

  func total_thread(request: ServerInfo_Empty, context: StatusOnlyCallContext) -> EventLoopFuture<ServerInfo_GetThreadResponse>
}

extension ServerInfo_ServerInfoProvider {
  internal var serviceName: Substring {
    return ServerInfo_ServerInfoServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "update_nts":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<ServerInfo_UpdateNTSReq>(),
        responseSerializer: ProtobufSerializer<ServerInfo_BaseResponse>(),
        interceptors: self.interceptors?.makeupdate_ntsInterceptors() ?? [],
        userFunction: self.update_nts(request:context:)
      )

    case "total_thread":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<ServerInfo_Empty>(),
        responseSerializer: ProtobufSerializer<ServerInfo_GetThreadResponse>(),
        interceptors: self.interceptors?.maketotal_threadInterceptors() ?? [],
        userFunction: self.total_thread(request:context:)
      )

    default:
      return nil
    }
  }
}

#if compiler(>=5.6)

/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
internal protocol ServerInfo_ServerInfoAsyncProvider: CallHandlerProvider {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: ServerInfo_ServerInfoServerInterceptorFactoryProtocol? { get }

  @Sendable func update_nts(
    request: ServerInfo_UpdateNTSReq,
    context: GRPCAsyncServerCallContext
  ) async throws -> ServerInfo_BaseResponse

  @Sendable func total_thread(
    request: ServerInfo_Empty,
    context: GRPCAsyncServerCallContext
  ) async throws -> ServerInfo_GetThreadResponse
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension ServerInfo_ServerInfoAsyncProvider {
  internal static var serviceDescriptor: GRPCServiceDescriptor {
    return ServerInfo_ServerInfoServerMetadata.serviceDescriptor
  }

  internal var serviceName: Substring {
    return ServerInfo_ServerInfoServerMetadata.serviceDescriptor.fullName[...]
  }

  internal var interceptors: ServerInfo_ServerInfoServerInterceptorFactoryProtocol? {
    return nil
  }

  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "update_nts":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<ServerInfo_UpdateNTSReq>(),
        responseSerializer: ProtobufSerializer<ServerInfo_BaseResponse>(),
        interceptors: self.interceptors?.makeupdate_ntsInterceptors() ?? [],
        wrapping: self.update_nts(request:context:)
      )

    case "total_thread":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<ServerInfo_Empty>(),
        responseSerializer: ProtobufSerializer<ServerInfo_GetThreadResponse>(),
        interceptors: self.interceptors?.maketotal_threadInterceptors() ?? [],
        wrapping: self.total_thread(request:context:)
      )

    default:
      return nil
    }
  }
}

#endif // compiler(>=5.6)

internal protocol ServerInfo_ServerInfoServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'update_nts'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeupdate_ntsInterceptors() -> [ServerInterceptor<ServerInfo_UpdateNTSReq, ServerInfo_BaseResponse>]

  /// - Returns: Interceptors to use when handling 'total_thread'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func maketotal_threadInterceptors() -> [ServerInterceptor<ServerInfo_Empty, ServerInfo_GetThreadResponse>]
}

internal enum ServerInfo_ServerInfoServerMetadata {
  internal static let serviceDescriptor = GRPCServiceDescriptor(
    name: "ServerInfo",
    fullName: "server_info.ServerInfo",
    methods: [
      ServerInfo_ServerInfoServerMetadata.Methods.update_nts,
      ServerInfo_ServerInfoServerMetadata.Methods.total_thread,
    ]
  )

  internal enum Methods {
    internal static let update_nts = GRPCMethodDescriptor(
      name: "update_nts",
      path: "/server_info.ServerInfo/update_nts",
      type: GRPCCallType.unary
    )

    internal static let total_thread = GRPCMethodDescriptor(
      name: "total_thread",
      path: "/server_info.ServerInfo/total_thread",
      type: GRPCCallType.unary
    )
  }
}
