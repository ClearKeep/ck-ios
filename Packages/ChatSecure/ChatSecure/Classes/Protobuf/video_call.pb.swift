// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: video_call.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct VideoCall_BaseResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var error: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct VideoCall_ServerResponse {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var groupRtcURL: String = String()

  var groupRtcID: Int64 = 0

  var groupRtcToken: String = String()

  var stunServer: VideoCall_StunServer {
    get {return _stunServer ?? VideoCall_StunServer()}
    set {_stunServer = newValue}
  }
  /// Returns true if `stunServer` has been explicitly set.
  var hasStunServer: Bool {return self._stunServer != nil}
  /// Clears the value of `stunServer`. Subsequent reads from it will return its default value.
  mutating func clearStunServer() {self._stunServer = nil}

  var turnServer: VideoCall_TurnServer {
    get {return _turnServer ?? VideoCall_TurnServer()}
    set {_turnServer = newValue}
  }
  /// Returns true if `turnServer` has been explicitly set.
  var hasTurnServer: Bool {return self._turnServer != nil}
  /// Clears the value of `turnServer`. Subsequent reads from it will return its default value.
  mutating func clearTurnServer() {self._turnServer = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _stunServer: VideoCall_StunServer? = nil
  fileprivate var _turnServer: VideoCall_TurnServer? = nil
}

struct VideoCall_StunServer {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var server: String = String()

  var port: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct VideoCall_TurnServer {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var server: String = String()

  var port: Int64 = 0

  var type: String = String()

  var user: String = String()

  var pwd: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Request: new call
struct VideoCall_VideoCallRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clientID: String = String()

  var groupID: Int64 = 0

  ///audio or video */
  var callType: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct VideoCall_WorkspaceVideoCallRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var fromClientID: String = String()

  var fromClientName: String = String()

  var fromClientAvatar: String = String()

  var fromClientWorkspaceDomain: String = String()

  var clientID: String = String()

  var groupID: Int64 = 0

  var callType: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Request: call update
struct VideoCall_UpdateCallRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var clientID: String = String()

  var groupID: Int64 = 0

  var updateType: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct VideoCall_WorkspaceUpdateCallRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var fromClientID: String = String()

  var fromClientName: String = String()

  var fromClientAvatar: String = String()

  var fromClientWorkspaceDomain: String = String()

  var clientID: String = String()

  var groupID: Int64 = 0

  var updateType: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "video_call"

extension VideoCall_BaseResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".BaseResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "error"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.error) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.error.isEmpty {
      try visitor.visitSingularStringField(value: self.error, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_BaseResponse, rhs: VideoCall_BaseResponse) -> Bool {
    if lhs.error != rhs.error {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCall_ServerResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ServerResponse"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "group_rtc_url"),
    2: .standard(proto: "group_rtc_id"),
    3: .standard(proto: "group_rtc_token"),
    4: .standard(proto: "stun_server"),
    5: .standard(proto: "turn_server"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.groupRtcURL) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.groupRtcID) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.groupRtcToken) }()
      case 4: try { try decoder.decodeSingularMessageField(value: &self._stunServer) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._turnServer) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.groupRtcURL.isEmpty {
      try visitor.visitSingularStringField(value: self.groupRtcURL, fieldNumber: 1)
    }
    if self.groupRtcID != 0 {
      try visitor.visitSingularInt64Field(value: self.groupRtcID, fieldNumber: 2)
    }
    if !self.groupRtcToken.isEmpty {
      try visitor.visitSingularStringField(value: self.groupRtcToken, fieldNumber: 3)
    }
    try { if let v = self._stunServer {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    } }()
    try { if let v = self._turnServer {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_ServerResponse, rhs: VideoCall_ServerResponse) -> Bool {
    if lhs.groupRtcURL != rhs.groupRtcURL {return false}
    if lhs.groupRtcID != rhs.groupRtcID {return false}
    if lhs.groupRtcToken != rhs.groupRtcToken {return false}
    if lhs._stunServer != rhs._stunServer {return false}
    if lhs._turnServer != rhs._turnServer {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCall_StunServer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".StunServer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "server"),
    2: .same(proto: "port"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.server) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.port) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.server.isEmpty {
      try visitor.visitSingularStringField(value: self.server, fieldNumber: 1)
    }
    if self.port != 0 {
      try visitor.visitSingularInt64Field(value: self.port, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_StunServer, rhs: VideoCall_StunServer) -> Bool {
    if lhs.server != rhs.server {return false}
    if lhs.port != rhs.port {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCall_TurnServer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TurnServer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "server"),
    2: .same(proto: "port"),
    3: .same(proto: "type"),
    4: .same(proto: "user"),
    5: .same(proto: "pwd"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.server) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.port) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.type) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.user) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.pwd) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.server.isEmpty {
      try visitor.visitSingularStringField(value: self.server, fieldNumber: 1)
    }
    if self.port != 0 {
      try visitor.visitSingularInt64Field(value: self.port, fieldNumber: 2)
    }
    if !self.type.isEmpty {
      try visitor.visitSingularStringField(value: self.type, fieldNumber: 3)
    }
    if !self.user.isEmpty {
      try visitor.visitSingularStringField(value: self.user, fieldNumber: 4)
    }
    if !self.pwd.isEmpty {
      try visitor.visitSingularStringField(value: self.pwd, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_TurnServer, rhs: VideoCall_TurnServer) -> Bool {
    if lhs.server != rhs.server {return false}
    if lhs.port != rhs.port {return false}
    if lhs.type != rhs.type {return false}
    if lhs.user != rhs.user {return false}
    if lhs.pwd != rhs.pwd {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCall_VideoCallRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".VideoCallRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "client_id"),
    2: .standard(proto: "group_id"),
    3: .standard(proto: "call_type"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.clientID) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.groupID) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.callType) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.clientID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientID, fieldNumber: 1)
    }
    if self.groupID != 0 {
      try visitor.visitSingularInt64Field(value: self.groupID, fieldNumber: 2)
    }
    if !self.callType.isEmpty {
      try visitor.visitSingularStringField(value: self.callType, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_VideoCallRequest, rhs: VideoCall_VideoCallRequest) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs.groupID != rhs.groupID {return false}
    if lhs.callType != rhs.callType {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCall_WorkspaceVideoCallRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".WorkspaceVideoCallRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "from_client_id"),
    2: .standard(proto: "from_client_name"),
    3: .standard(proto: "from_client_avatar"),
    4: .standard(proto: "from_client_workspace_domain"),
    5: .standard(proto: "client_id"),
    6: .standard(proto: "group_id"),
    7: .standard(proto: "call_type"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.fromClientID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.fromClientName) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.fromClientAvatar) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.fromClientWorkspaceDomain) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.clientID) }()
      case 6: try { try decoder.decodeSingularInt64Field(value: &self.groupID) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.callType) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.fromClientID.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientID, fieldNumber: 1)
    }
    if !self.fromClientName.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientName, fieldNumber: 2)
    }
    if !self.fromClientAvatar.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientAvatar, fieldNumber: 3)
    }
    if !self.fromClientWorkspaceDomain.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientWorkspaceDomain, fieldNumber: 4)
    }
    if !self.clientID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientID, fieldNumber: 5)
    }
    if self.groupID != 0 {
      try visitor.visitSingularInt64Field(value: self.groupID, fieldNumber: 6)
    }
    if !self.callType.isEmpty {
      try visitor.visitSingularStringField(value: self.callType, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_WorkspaceVideoCallRequest, rhs: VideoCall_WorkspaceVideoCallRequest) -> Bool {
    if lhs.fromClientID != rhs.fromClientID {return false}
    if lhs.fromClientName != rhs.fromClientName {return false}
    if lhs.fromClientAvatar != rhs.fromClientAvatar {return false}
    if lhs.fromClientWorkspaceDomain != rhs.fromClientWorkspaceDomain {return false}
    if lhs.clientID != rhs.clientID {return false}
    if lhs.groupID != rhs.groupID {return false}
    if lhs.callType != rhs.callType {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCall_UpdateCallRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".UpdateCallRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "client_id"),
    2: .standard(proto: "group_id"),
    3: .standard(proto: "update_type"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.clientID) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.groupID) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.updateType) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.clientID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientID, fieldNumber: 1)
    }
    if self.groupID != 0 {
      try visitor.visitSingularInt64Field(value: self.groupID, fieldNumber: 2)
    }
    if !self.updateType.isEmpty {
      try visitor.visitSingularStringField(value: self.updateType, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_UpdateCallRequest, rhs: VideoCall_UpdateCallRequest) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs.groupID != rhs.groupID {return false}
    if lhs.updateType != rhs.updateType {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension VideoCall_WorkspaceUpdateCallRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".WorkspaceUpdateCallRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "from_client_id"),
    2: .standard(proto: "from_client_name"),
    3: .standard(proto: "from_client_avatar"),
    4: .standard(proto: "from_client_workspace_domain"),
    5: .standard(proto: "client_id"),
    6: .standard(proto: "group_id"),
    7: .standard(proto: "update_type"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.fromClientID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.fromClientName) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.fromClientAvatar) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.fromClientWorkspaceDomain) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.clientID) }()
      case 6: try { try decoder.decodeSingularInt64Field(value: &self.groupID) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.updateType) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.fromClientID.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientID, fieldNumber: 1)
    }
    if !self.fromClientName.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientName, fieldNumber: 2)
    }
    if !self.fromClientAvatar.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientAvatar, fieldNumber: 3)
    }
    if !self.fromClientWorkspaceDomain.isEmpty {
      try visitor.visitSingularStringField(value: self.fromClientWorkspaceDomain, fieldNumber: 4)
    }
    if !self.clientID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientID, fieldNumber: 5)
    }
    if self.groupID != 0 {
      try visitor.visitSingularInt64Field(value: self.groupID, fieldNumber: 6)
    }
    if !self.updateType.isEmpty {
      try visitor.visitSingularStringField(value: self.updateType, fieldNumber: 7)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: VideoCall_WorkspaceUpdateCallRequest, rhs: VideoCall_WorkspaceUpdateCallRequest) -> Bool {
    if lhs.fromClientID != rhs.fromClientID {return false}
    if lhs.fromClientName != rhs.fromClientName {return false}
    if lhs.fromClientAvatar != rhs.fromClientAvatar {return false}
    if lhs.fromClientWorkspaceDomain != rhs.fromClientWorkspaceDomain {return false}
    if lhs.clientID != rhs.clientID {return false}
    if lhs.groupID != rhs.groupID {return false}
    if lhs.updateType != rhs.updateType {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}