//
//  CallBox.swift
//  ClearKeep
//
//  Created by VietAnh on 1/7/21.
//

import Foundation
import AVFoundation

public enum CallStatus {
	case calling
	case ringing
	case answered
	case busy
	case ended
}

public final class CallBox: NSObject {
	
	// MARK: Metadata Properties
	public let uuid: UUID
	public let clientId: String
	public let rtcUrl: String
	public var groupToken: String?
	public var clientName: String?
	public var roomId: Int64 = 0
	public var avatar: String?
	public let isOutgoing: Bool
	public var status = CallStatus.calling
	public var type: CallType = .audio
	public var isCallGroup = false
	public var isCamera = true
	public var roomRtcId: Int64 = 0
	
	// MARK: Call State Properties
	
	public var connectingDate: Date? {
		didSet {
			stateDidChange?()
			hasStartedConnectingDidChange?()
		}
	}
	
	public var connectDate: Date? {
		didSet {
			stateDidChange?()
			hasConnectedDidChange?()
		}
	}
	
	public var endDate: Date? {
		didSet {
			status = .ended
			stateDidChange?()
			hasEndedDidChange?()
		}
	}
	
	public var isOnHold = false {
		didSet {
			//            publisher?.publishAudio = !isOnHold
			stateDidChange?()
		}
	}
	
	public var isMuted = false {
		didSet {
			//            publisher?.publishAudio = !isMuted
		}
	}
	
	// MARK: State change callback blocks
	
	public var stateDidChange: (() -> Void)?
	public var hasStartedConnectingDidChange: (() -> Void)?
	public var hasConnectedDidChange: (() -> Void)?
	public var hasEndedDidChange: (() -> Void)?
	public var audioChange: (() -> Void)?
	public var renderView: (() -> Void)?
	public var renderSizeChangeWithSize: ((_ size: CGSize, _ uId: Int) -> Void)?
	public var membersInCallDidChange: (() -> Void)?
	
	// MARK: Derived Properties
	
	var hasStartedConnecting: Bool {
		get {
			return connectingDate != nil
		}
		set {
			connectingDate = newValue ? Date() : nil
		}
	}
	var hasConnected: Bool {
		get {
			return connectDate != nil
		}
		set {
			connectDate = newValue ? Date() : nil
		}
	}
	var hasEnded: Bool {
		get {
			return endDate != nil
		}
		set {
			endDate = newValue ? Date() : nil
		}
	}
	var duration: TimeInterval {
		guard let connectDate = connectDate else {
			return 0
		}
		
		return Date().timeIntervalSince(connectDate)
	}
	
	// MARK: Initialization
	
	init(uuid: UUID, clientId: String, isOutgoing: Bool = false, rtcUrl: String) {
		self.uuid = uuid
		self.clientId = clientId
		self.isOutgoing = isOutgoing
		self.rtcUrl = rtcUrl
	}
	
	// MARK: Actions
	public var videoRoom: JanusVideoRoom?
	
	var canStartCall: ((Bool) -> Void)?
	func startCall(withAudioSession audioSession: AVAudioSession?, completion: ((_ success: Bool) -> Void)?) {
		//        OTAudioDeviceManager.setAudioDevice(OTDefaultAudioDevice.sharedInstance(with: audioSession))
		if videoRoom == nil {
			videoRoom = JanusVideoRoom(delegate: self, token: groupToken, rtcUrl: rtcUrl)
		}
		canStartCall = completion
		
		hasStartedConnecting = true
		videoRoom?.publisher?.janus?.connect(completion: { (error) in
			if let error = error {
				print(error.localizedDescription)
				completion?(false)
			} else {
				completion?(true)
			}
		})
	}
	
	var canAnswerCall: ((Bool) -> Void)?
	func answerCall(withAudioSession audioSession: AVAudioSession, completion: ((_ success: Bool) -> Void)?) {
		//        OTAudioDeviceManager.setAudioDevice(OTDefaultAudioDevice.sharedInstance(with: audioSession))
		if videoRoom == nil {
			videoRoom = JanusVideoRoom(delegate: self, token: groupToken, rtcUrl: rtcUrl)
		}
		
		canAnswerCall = completion
		
		hasStartedConnecting = true
		videoRoom?.publisher?.janus?.connect(completion: { (error) in
			if let error = error {
				print(error.localizedDescription)
				completion?(false)
			} else {
				completion?(true)
			}
		})
	}
	
	func startJoinRoom() {
		videoRoom?.joinRoom(withRoomId: roomId, username: clientName ?? "iOS", completeCallback: { [weak self] isSuccess, error in
			guard let self = self else { return }
			if error != nil || !isSuccess {
				print(error?.localizedDescription ?? "")
				CallManager.shared.end(call: self)
			} else {
				self.status = .ringing
				self.stateDidChange?()
				self.videoRoom?.publisher?.localVideoTrack.isEnabled = self.type == .video
			}
		})
	}
	
	func endCall() {
		/*
		 Simulate the end taking effect immediately, since
		 the example app is not backed by a real network service
		 */
		
		if let videoRoom = self.videoRoom {
			videoRoom.leaveRoom(callback: nil)
			videoRoom.leaveRoom {
				videoRoom.publisher?.delegate = nil
				videoRoom.publisher = nil
			}
		}
		videoRoom = nil
		hasEnded = true
	}
	
	func camera(isEnable: Bool) {
		sendData(dictData: ["action": "camera", "enable": isEnable])
	}
	
	func micro(isEnable: Bool) {
		sendData(dictData: ["action": "micro", "enable": isEnable])
	}
	
	func sendData(dictData: [String: Any]) {
		do {
			let data = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
			videoRoom?.publisher?.sendData(data)
		} catch {
			debugPrint("error: \(error.localizedDescription)")
		}
	}
}

// MARK: - JanusVideoRoomDelegate

extension CallBox: JanusVideoRoomDelegate {
	func janusVideoRoom(janusRoom: JanusVideoRoom, remoteLeaveWithID clientId: Int) {
		if self.isCallGroup {
			let numberOfRemotes = videoRoom?.remotes.count ?? 0
			if numberOfRemotes > 0 {
				membersInCallDidChange?()
			} else {
				// Note: Keep the call so that other could join, uncomment to end call instead
				// CallManager.shared.end(call: self)
				membersInCallDidChange?()
			}
		} else {
			CallManager.shared.end(call: self)
		}
		print("=================>>>>>>>>>>>>>>>>>>> remoteLeaveWithID")
	}
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, didJoinRoomWithId clientId: Int) {
		status = .ringing
		self.stateDidChange?()
		print("=================>>>>>>>>>>>>>>>>>>> didJoinRoomWithId")
	}
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, remoteUnPublishedWithUid clientId: Int) {
		if self.isCallGroup {
			// TODO: check if only 2 members
			let numberOfRemotes = videoRoom?.remotes.count ?? 0
			if numberOfRemotes == 0 {
				CallManager.shared.end(call: self)
			} else {
				// membersInCallDidChange?()
			}
		} else {
			CallManager.shared.end(call: self)
		}
		print("=================>>>>>>>>>>>>>>>>>>> remoteUnPublishedWithUid")
	}
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, firstFrameDecodeWithSize size: CGSize, uId: Int) {
		print("=================>>>>>>>>>>>>>>>>>>> firstFrameDecodeWithSize")
		status = .answered
		self.stateDidChange?()
		self.renderSizeChangeWithSize?(size, uId)
	}
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, renderSizeChangeWithSize size: CGSize, uId: Int) {
		print("=================>>>>>>>>>>>>>>>>>>> renderSizeChangeWithSize")
		self.renderSizeChangeWithSize?(size, uId)
	}
	
	func janusVideoRoom(janusRoom: JanusVideoRoom, fatalErrorWithID code: RTCErrorCode) {
		CallManager.shared.end(call: self)
	}
}
