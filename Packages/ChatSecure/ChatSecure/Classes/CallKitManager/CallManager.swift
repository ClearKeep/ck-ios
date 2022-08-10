//
//  CallManager.swift
//  ClearKeep
//
//  Created by VietAnh on 1/4/21.
//

import UIKit
import CallKit
import AVFoundation
import PushKit

public enum CallType: String {
	case audio
	case video
	case cancelRequestCall = "cancel_request_call"
}

final public class CallManager: NSObject {
	enum Call: String {
		case start = "startCall"
		case end = "endCall"
		case hold = "holdCall"
	}
	
	public var awaitCallGroup: Int?
	var answerCall: CallBox?
	var outgoingCall: CallBox?
	public var endCall: ((CallBox) -> Void)?
	let callController = CXCallController()
	static let CallsChangedNotification = Notification.Name("CallManagerCallsChangedNotification")
	private let provider: CXProvider
	public var calls = [CallBox]()
	/// The app's provider configuration, representing its CallKit capabilities
	static var providerConfiguration: CXProviderConfiguration {
		let localizedName = NSLocalizedString("ClearKeep", comment: "Name of application")
		let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
		providerConfiguration.supportsVideo = true
		//        providerConfiguration.maximumCallsPerCallGroup = 2
		providerConfiguration.supportedHandleTypes = [.phoneNumber]
		//        providerConfiguration.iconTemplateImageData = #imageLiteral(resourceName: "IconMask").pngData()
		providerConfiguration.ringtoneSound = "Ringtone.caf"
		return providerConfiguration
	}
	
	public static let shared = CallManager()
	
	override init() {
		provider = CXProvider(configuration: type(of: self).providerConfiguration)
		super.init()
		provider.setDelegate(self, queue: nil)
	}
	
	// MARK: Actions
	public func startCall(clientId: String,
				   clientName: String?,
				   avatar: String? = nil,
				   groupId: Int64,
				   groupToken: String,
				   callType type: CallType = .audio ,
				   isCallGroup: Bool,
				   groupRtcUrl: String) {
		let call = CallBox(uuid: UUID(), clientId: clientId, isOutgoing: true, rtcUrl: groupRtcUrl)
		call.clientName = clientName
		call.groupToken = groupToken
		call.avatar = avatar
		call.roomId = groupId
		call.type = type
		call.isCallGroup = isCallGroup
		call.hasStartedConnectingDidChange = { [weak self] in
			guard let self = self else { return }
			self.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: call.connectingDate)
		}
		call.hasConnectedDidChange = { [weak self] in
			guard let self = self else { return }
			self.provider.reportOutgoingCall(with: call.uuid, connectedAt: call.connectDate)
		}
		
		self.outgoingCall = call
		self.addCall(call)
		
		let receiverName = (clientName ?? "").isEmpty ? clientId : clientName
		let handle = CXHandle(type: .generic, value: receiverName ?? "")
		let startCallAction = CXStartCallAction(call: call.uuid, handle: handle)
		
		startCallAction.isVideo = true
		let transaction = CXTransaction()
		transaction.addAction(startCallAction)
		requestTransaction(transaction, action: Call.start.rawValue)
	}
	
	public func end(call: CallBox) {
		let endCallAction = CXEndCallAction(call: call.uuid)
		let transaction = CXTransaction()
		transaction.addAction(endCallAction)
		call.endCall()
		requestTransaction(transaction, action: Call.end.rawValue)
		removeCall(call)
	}
	
	//    func leaveRoom(call: CallBox){
	//        call.videoRoom?.stopListenRemote(remoteRole: <#T##JanusRoleListen#>)
	//    }
	
	func setHeld(call: CallBox, onHold: Bool) {
		let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
		let transaction = CXTransaction()
		transaction.addAction(setHeldCallAction)
		
		requestTransaction(transaction, action: Call.hold.rawValue)
	}
	
	private func requestTransaction(_ transaction: CXTransaction, action: String = "") {
		callController.request(transaction) { error in
			if let error = error {
				print("Error requesting transaction: \(error)")
			} else {
				print("Requested transaction \(action) successfully")
			}
		}
	}
	
	// MARK: Call Management
	private func callWithUUID(uuid: UUID) -> CallBox? {
		guard let index = calls.firstIndex(where: { $0.uuid == uuid }) else {
			return nil
		}
		return calls[index]
	}
	
	private func addCall(_ call: CallBox) {
		calls.append(call)
		
		call.stateDidChange = { [weak self] in
			guard let self = self else { return }
			self.postCallsChangedNotification()
		}
		
		postCallsChangedNotification(userInfo: ["action": Call.start.rawValue])
	}
	
	private func removeCall(_ call: CallBox) {
		//        calls = calls.filter {$0 === call}
		self.endCall?(call)
		postCallsChangedNotification(userInfo: ["action": Call.end.rawValue])
		calls.removeAll()
	}
	
	private func removeAllCalls() {
		calls.removeAll()
		postCallsChangedNotification(userInfo: ["action": Call.end.rawValue])
	}
	
	private func postCallsChangedNotification(userInfo: [String: Any]? = nil) {
		NotificationCenter.default.post(name: type(of: self).CallsChangedNotification, object: self, userInfo: userInfo)
	}
	
	public func handleIncomingPushEvent(payload: PKPushPayload, completion: ((NSError?) -> Void)? = nil) {
		print("Payload: \(payload.dictionaryPayload)")
		let decoder = JSONDecoder()
		guard let data = try? JSONSerialization.data(withJSONObject: payload.dictionaryPayload, options: []),
				  let callNotification = try? decoder.decode(CallNotification.self, from: data) else {
					  return
				  }
		
		if let currentUserId = callNotification.publication?.clientID,
			let savedCurrentUserId = DependencyResolver.shared.channelStorage.currentServer?.profile?.userId, currentUserId != savedCurrentUserId {
			print("This call is not belong to me")
			print("\(currentUserId) # \(savedCurrentUserId)")
			return
		}
		
		if self.calls.first(where: { $0.roomId == Int64(callNotification.publication?.groupID ?? "0") }) != nil || Int64(callNotification.publication?.groupID ?? "0") ?? 0 == awaitCallGroup ?? -1 {
			return
		}
		
		self.awaitCallGroup = Int(callNotification.publication?.groupID ?? "-1")
		
		if let username = callNotification.publication?.fromClientName,
		   let roomId = callNotification.publication?.groupID,
		   let clientId = callNotification.publication?.fromClientID,
		   let callType = callNotification.publication?.callType,
		   let groupRtcUrl = callNotification.publication?.groupRTCURL {
			let avatar = callNotification.publication?.fromClientAvatar
			let token = callNotification.publication?.groupRTCToken
			let groupType = callNotification.publication?.groupType
			let groupName = callNotification.publication?.groupName
			
			// Save turnUser and turnPwd
			let turnString = callNotification.publication?.turnServer ?? ""
			let stunString = callNotification.publication?.stunServer ?? ""
			
			let turnData = Data(turnString.utf8)
			let stunData = Data(stunString.utf8)
			do {
				// make sure this JSON is in the format we expect
				if let turnJson = try JSONSerialization.jsonObject(with: turnData, options: []) as? [String: Any],
				   let stunJson = try JSONSerialization.jsonObject(with: stunData, options: []) as? [String: Any] {
					let turnUser = turnJson["user"] as? String
					let turnPwd = turnJson["pwd"] as? String
					let turnServer = turnJson["server"] as? String
					let stunServer = stunJson["server"] as? String
					
					UserDefaults.standard.setValue(turnUser, forKey: Constants.keySaveTurnServerUser)
					UserDefaults.standard.setValue(turnPwd, forKey: Constants.keySaveTurnServerPWD)
					UserDefaults.standard.setValue(turnServer, forKey: Constants.keySaveTurnServer)
					UserDefaults.standard.setValue(stunServer, forKey: Constants.keySaveStunServer)
					UserDefaults.standard.synchronize()
				}
			} catch let error as NSError {
				print("Failed to load: \(error.localizedDescription)")
			}
			
			let hasVideo = callType == "video"
			let isGroupCall = groupType == "group"
			let callerName = isGroupCall ? groupName : username
			reportIncomingCall(isCallGroup: isGroupCall,
							   roomId: roomId,
							   clientId: clientId,
							   avatar: avatar,
							   token: token,
							   callerName: callerName ?? "",
							   hasVideo: hasVideo,
							   groupRtcUrl: groupRtcUrl,
							   completion: completion)
		}
	}
	
	public func handleVideoCall(payload: PKPushPayload) {
		print("Payload video: \(payload.dictionaryPayload)")
		let decoder = JSONDecoder()
		guard let data = try? JSONSerialization.data(withJSONObject: payload.dictionaryPayload, options: []),
				  let callNotification = try? decoder.decode(CallNotification.self, from: data) else {
					  return
				  }
		
		if let currentUserId = callNotification.publication?.clientID,
			let savedCurrentUserId = DependencyResolver.shared.channelStorage.currentServer?.profile?.userId, currentUserId != savedCurrentUserId {
			print("This call is not belong to me")
			print("\(currentUserId) # \(savedCurrentUserId)")
			return
		}
		
		if let index = self.calls.firstIndex(where: { item in
			item.roomId == Int64(callNotification.publication?.groupID ?? "0")
		}) {
			self.calls[index].type = .video
			NotificationCenter.default.post(name: Notification.Name.CallService.changeTypeCall, object: callNotification.publication)
		}
	}
	
	public func handleBusyCall(payload: PKPushPayload) {
		print("Payload busy: \(payload.dictionaryPayload)")
		let decoder = JSONDecoder()
		guard let data = try? JSONSerialization.data(withJSONObject: payload.dictionaryPayload, options: []),
				  let callNotification = try? decoder.decode(CallNotification.self, from: data) else {
					  return
				  }
		
		if let currentUserId = callNotification.publication?.clientID,
			let savedCurrentUserId = DependencyResolver.shared.channelStorage.currentServer?.profile?.userId, currentUserId != savedCurrentUserId {
			print("This call is not belong to me")
			print("\(currentUserId) # \(savedCurrentUserId)")
			return
		}
		
		if let index = self.calls.firstIndex(where: { item in
			item.roomId == Int64(callNotification.publication?.groupID ?? "0") && !item.isCallGroup
		}) {
			self.calls[index].status = .busy
			NotificationCenter.default.post(name: Notification.Name.CallService.changeStatusBusyCall, object: nil)
		}
	}
}

extension CallManager {
	// MARK: Incoming Calls
	/// Use CXProvider to report the incoming call to the system
	func reportIncomingCall(isCallGroup: Bool, roomId: String, clientId: String, avatar: String?, token: String?, callerName: String, hasVideo: Bool = true, groupRtcUrl: String, completion: ((NSError?) -> Void)? = nil) {
		// Construct a CXCallUpdate describing the incoming call, including the caller.
		let update = CXCallUpdate()
		update.remoteHandle = CXHandle(type: .generic, value: callerName)
		update.hasVideo = hasVideo
		update.supportsHolding = true
		
		let uuid = UUID()
		// pre-heat the AVAudioSession
		// OTAudioDeviceManager.setAudioDevice(OTDefaultAudioDevice.sharedInstance())
		
		// Report the incoming call to the system
		provider.reportNewIncomingCall(with: uuid, update: update) { [weak self] error in
			guard let self = self else { return }
			/*
			 Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
			 since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
			 */
			if error == nil {
				let call = CallBox(uuid: uuid, clientId: clientId, rtcUrl: groupRtcUrl)
				call.clientName = callerName
				call.roomId = Int64(roomId) ?? 0
				call.groupToken = token
				call.avatar = avatar
				call.isCallGroup = isCallGroup
				call.type = hasVideo ? .video : .audio
				self.addCall(call)
			}
			self.awaitCallGroup = nil
			completion?(error as NSError?)
		}
	}
	
	func sendFakeAudioInterruptionNotificationToStartAudioResources() {
		var userInfo = [AnyHashable: Any]()
		let interrupttioEndedRaw = AVAudioSession.InterruptionType.ended.rawValue
		userInfo[AVAudioSessionInterruptionTypeKey] = interrupttioEndedRaw
		NotificationCenter.default.post(name: AVAudioSession.interruptionNotification, object: self, userInfo: userInfo)
	}
	
	func configureAudioSession() {
		// See https://forums.developer.apple.com/thread/64544
		let session = AVAudioSession.sharedInstance()
		do {
			try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
			try session.setActive(true)
			try session.setMode(AVAudioSession.Mode.voiceChat)
			try session.setPreferredSampleRate(44100.0)
			try session.setPreferredIOBufferDuration(0.005)
		} catch {
			print(error)
		}
	}
}

extension CallManager: CXProviderDelegate {
	public func providerDidReset(_ provider: CXProvider) {
		print("Provider did reset")
		/*
		 End any ongoing calls if the provider resets, and remove them from the app's list of calls,
		 since they are no longer valid.
		 */
	}
	
	public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
		/*
		 Configure the audio session, but do not start call audio here, since it must be done once
		 the audio session has been activated by the system after having its priority elevated.
		 */
		// https://forums.developer.apple.com/thread/64544
		// we can't configure the audio session here for the case of launching it from locked screen
		// instead, we have to pre-heat the AVAudioSession by configuring as early as possible, didActivate do not get called otherwise
		// please look for  * pre-heat the AVAudioSession *
		configureAudioSession()
		
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name.CallService.receiveCall, object: nil)
		}
		// Signal to the system that the action has been successfully performed.
		action.fulfill()
	}
	
	public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
		// Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
		guard let call = callWithUUID(uuid: action.callUUID) else {
			action.fail()
			return
		}
		
		/*
		 Configure the audio session, but do not start call audio here, since it must be done once
		 the audio session has been activated by the system after having its priority elevated.
		 */
		
		// https://forums.developer.apple.com/thread/64544
		// we can't configure the audio session here for the case of launching it from locked screen
		// instead, we have to pre-heat the AVAudioSession by configuring as early as possible, didActivate do not get called otherwise
		// please look for  * pre-heat the AVAudioSession *
		configureAudioSession()
		
		answerCall = call
		
		// Signal to the system that the action has been successfully performed.
		action.fulfill()
	}
	
	public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
		// Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
		guard let call = callWithUUID(uuid: action.callUUID) else {
			action.fail()
			return
		}
		
		// Trigger the call to be ended via the underlying network service.
		call.endCall()
		
		// Signal to the system that the action has been successfully performed.
		action.fulfill()
		
		// Remove the ended call from the app's list of calls.
		removeCall(call)
	}
	
	public func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
		// Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
		guard let call = callWithUUID(uuid: action.callUUID) else {
			action.fail()
			return
		}
		// Update the SpeakerboxCall's underlying hold state.
		call.isOnHold = action.isOnHold
		
		// Stop or start audio in response to holding or unholding the call.
		call.isMuted = call.isOnHold
		
		// Signal to the system that the action has been successfully performed.
		action.fulfill()
	}
	
	public func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
		// Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
		guard let call = callWithUUID(uuid: action.callUUID) else {
			action.fail()
			return
		}
		call.isMuted = action.isMuted
		
		// Signal to the system that the action has been successfully performed.
		action.fulfill()
	}
	
	public func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
		print("Timed out \(#function)")
		// React to the action timeout if necessary, such as showing an error UI.
	}
	
	public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
		print("Received \(#function)")
		// If we are returning from a hold state
		if answerCall?.hasConnected ?? false {
			// configureAudioSession()
			// See more details on how this works in the OTDefaultAudioDevice.m method handleInterruptionEvent
			sendFakeAudioInterruptionNotificationToStartAudioResources()
			return
		}
		if outgoingCall?.hasConnected ?? false {
			// configureAudioSession()
			// See more details on how this works in the OTDefaultAudioDevice.m method handleInterruptionEvent
			sendFakeAudioInterruptionNotificationToStartAudioResources()
			return
		}
		
		// Start call audio media, now that the audio session has been activated after having its priority boosted.
		outgoingCall?.startCall(withAudioSession: audioSession) { [weak self] isSuccess in
			guard let self = self else { return }
			if isSuccess {
				self.outgoingCall?.startJoinRoom()
			} else {
				if let outgoingCall = self.outgoingCall {
					self.end(call: outgoingCall)
				}
			}
		}
		
		answerCall?.answerCall(withAudioSession: audioSession) { [weak self] isSuccess in
			guard let self = self else { return }
			if isSuccess {
				DispatchQueue.main.async {
					NotificationCenter.default.post(name: NSNotification.Name.CallService.receiveCall, object: nil)
				}
				self.answerCall?.startJoinRoom()
			}
		}
	}
	
	public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
		print("Received \(#function)")
		
		/*
		 Restart any non-call related audio now that the app's audio session has been
		 de-activated after having its priority restored to normal.
		 */
		if outgoingCall?.isOnHold ?? false || answerCall?.isOnHold ?? false {
			print("Call is on hold. Do not terminate any call")
			return
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.outgoingCall?.endCall()
			self.outgoingCall = nil
			self.answerCall?.endCall()
			self.answerCall = nil
			self.removeAllCalls()
			NotificationCenter.default.post(name: NSNotification.Name.CallService.endCall, object: nil)
		}
	}
}

public extension Notification.Name {
	public enum CallService {
		public static let receiveCall = Notification.Name("CallService.receiveCall")
		public static let endCall = Notification.Name("CallService.endCall")
		public static let notification = NSNotification.Name.init("notification")
		public static let changeTypeCall = NSNotification.Name.init("changeTypeCall")
		public static let changeStatusBusyCall = NSNotification.Name.init("changeStatusBusyCall")
	}
}
