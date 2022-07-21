//
//  CallBox.swift
//  ClearKeep
//
//  Created by VietAnh on 1/7/21.
//

import Foundation
import AVFoundation

enum CallStatus {
	case calling
	case ringing
	case answered
	case busy
	case ended
}

final class CallBox: NSObject {
	
	// MARK: Metadata Properties
	let uuid: UUID
	let clientId: String
	var clientName: String?
	var avatar: String?
	let isOutgoing: Bool
	let callServer: CallServer
	var status = CallStatus.calling
	var type: CallType = .audio
	var isCallGroup = false
	
	// MARK: Call State Properties
	
	var connectingDate: Date? {
		didSet {
			stateDidChange?()
			hasStartedConnectingDidChange?()
		}
	}
	var connectDate: Date? {
		didSet {
			stateDidChange?()
			hasConnectedDidChange?()
		}
	}
	var endDate: Date? {
		didSet {
			status = .ended
			stateDidChange?()
			hasEndedDidChange?()
		}
	}
	var isOnHold = false {
		didSet {
			//            publisher?.publishAudio = !isOnHold
			stateDidChange?()
		}
	}
	
	var isMuted = false {
		didSet {
			//            publisher?.publishAudio = !isMuted
		}
	}
	
	// MARK: State change callback blocks
	
	var stateDidChange: (() -> Void)?
	var hasStartedConnectingDidChange: (() -> Void)?
	var hasConnectedDidChange: (() -> Void)?
	var hasEndedDidChange: (() -> Void)?
	var audioChange: (() -> Void)?
	var renderView: (() -> Void)?
	var renderSizeChangeWithSize: ((_ size: CGSize, _ uId: Int) -> Void)?
	var membersInCallDidChange: (() -> Void)?
	
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
	
	init(uuid: UUID, clientId: String, callServer: CallServer, isOutgoing: Bool = false) {
		self.uuid = uuid
		self.clientId = clientId
		self.callServer = callServer
		self.isOutgoing = isOutgoing
	}
	
	// MARK: Actions
	var videoRoom: JanusVideoRoom?
	
	var canStartCall: ((Bool) -> Void)?
	func startCall(withAudioSession audioSession: AVAudioSession?, completion: ((_ success: Bool) -> Void)?) {
		//        OTAudioDeviceManager.setAudioDevice(OTDefaultAudioDevice.sharedInstance(with: audioSession))
		if videoRoom == nil {
			videoRoom = JanusVideoRoom(delegate: self, callServer: callServer)
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
			videoRoom = JanusVideoRoom(delegate: self, callServer: callServer)
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
		videoRoom?.joinRoom(withRoomId: callServer.groupRtcId, username: clientName ?? "iOS", completeCallback: { [weak self] isSuccess, error in
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
