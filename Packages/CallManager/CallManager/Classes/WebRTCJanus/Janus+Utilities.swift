//
//  Janus+Utilities.swift
//  JanusWebRTC
//
//  Created by VietAnh on 12/18/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

// swiftlint:disable function_body_length

import Foundation
import WebRTC

func randomString(withLength len: Int) -> String {
	let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	return String((0...(len - 1)).map { _ in letters.randomElement() ?? "a" })
}

func asyncInMainThread(_ block: @escaping () -> Void) {
	if Thread.isMainThread {
		block()
	} else {
		DispatchQueue.main.async(execute: block)
	}
}

func descriptionForDescription(description: RTCSessionDescription,
							   preferredForDescription codec: String) -> RTCSessionDescription {
	let sdpString = description.sdp
	let lineSeparator = "\n"
	let mLineSeparator = " "
	// Copied from PeerConnectionClient.java.
	// TODO(tkchin): Move this to a shared C++ file.
	var lines = sdpString.components(separatedBy: lineSeparator)
	// Find the line starting with "m=video".
	var mLineIndex = -1
	for index in 0..<lines.count {
		if lines[index].hasPrefix("m=video") {
			mLineIndex = index
			break
		}
	}
	if mLineIndex == -1 {
		debugPrint("No m=video line, so can't prefer %@", codec)
		return description
	}
	// An array with all payload types with name |codec|. The payload types are
	// integers in the range 96-127, but they are stored as strings here.
	var codecPayloadTypes: [String] = []
	// a=rtpmap:<payload type> <encoding name>/<clock rate>
	// [/<encoding parameters>]
	let pattern = "^a=rtpmap:(\\d+) \(codec)(/\\d+)+[\r]?$"
	var regex: NSRegularExpression?
	do {
		regex = try NSRegularExpression(
			pattern: pattern,
			options: [])
	} catch {
	}
	for line in lines {
		let codecMatches = regex?.firstMatch(
			in: line,
			options: [],
			range: NSRange(location: 0, length: line.count))
		if let codecMatches = codecMatches {
			codecPayloadTypes.append(
				(line as NSString).substring(with: codecMatches.range(at: 1)))
		}
	}
	
	do {
		let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		for line in lines {
			if let codeMatches = regex.firstMatch(in: line,
												  options: .reportProgress,
												  range: NSRange(location: 0, length: line.count)) {
				let range = codeMatches.range(at: 1)
				let myNSString = line as NSString
				let subStr = myNSString.substring(with: range)
				codecPayloadTypes.append(subStr)
			}
		}
		if codecPayloadTypes.count == 0 {
			debugPrint("No payload types with name %@", codec)
			return description
		}
		let origMLineParts = lines[mLineIndex].components(separatedBy: mLineSeparator)
		// The format of ML should be: m=<media> <port> <proto> <fmt> ...
		let kHeaderLength = 3
		if origMLineParts.count <= kHeaderLength {
			debugPrint("Wrong SDP media description format: %@", lines[mLineIndex])
			return description
		}
		// Split the line into header and payloadTypes.
		let payloadRange = NSRange(location: kHeaderLength, length: origMLineParts.count - kHeaderLength)
		let header = origMLineParts[0...kHeaderLength]
		var payloadTypes = origMLineParts[kHeaderLength...payloadRange.length]
		// Reconstruct the line with |codecPayloadTypes| moved to the beginning of the
		// payload types.
		var newMLineParts = [String]()
		newMLineParts.append(contentsOf: header)
		newMLineParts.append(contentsOf: codecPayloadTypes)
		payloadTypes = payloadTypes.filter({ !codecPayloadTypes.contains($0) })
		newMLineParts.append(contentsOf: payloadTypes)
		
		let newMLine = newMLineParts.joined(separator: mLineSeparator)
		lines[mLineIndex] = newMLine
		
		let mangledSdpString = lines.joined(separator: lineSeparator)
		return RTCSessionDescription(
			type: description.type,
			sdp: mangledSdpString)
	} catch {
		
	}
	return RTCSessionDescription(type: description.type, sdp: "")
}

extension String {
	subscript(_ offsetBy: Int) -> String {
		let idx1 = index(startIndex, offsetBy: offsetBy)
		let idx2 = index(idx1, offsetBy: 1)
		return String(self[idx1..<idx2])
	}
	
	subscript (range: Range<Int>) -> String {
		let start = index(startIndex, offsetBy: range.lowerBound)
		let end = index(startIndex, offsetBy: range.upperBound)
		return String(self[start ..< end])
	}
	
	subscript (range: CountableClosedRange<Int>) -> String {
		let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
		let endIndex = self.index(startIndex, offsetBy: range.upperBound - range.lowerBound)
		return String(self[startIndex...endIndex])
	}
}
func availableVideoResolutions() -> [String]? {
	var resolutions: Set<[NSNumber]> = []
	for device in RTCCameraVideoCapturer.captureDevices() {
		for format in RTCCameraVideoCapturer.supportedFormats(for: device) {
			var resolution: CMVideoDimensions?
			if let formatDescription = format.formatDescription as? CMVideoFormatDescription {
				resolution = CMVideoFormatDescriptionGetDimensions(formatDescription)
			}
			let resolutionObject = [NSNumber(value: resolution?.width ?? 0), NSNumber(value: resolution?.height ?? 0)]
			resolutions.insert(resolutionObject)
		}
	}
	var resolutionStrings: [String] = []
	for resolution in resolutions {
		let resolutionString = "\(resolution.first ?? 0)x\(resolution.last ?? 0)"
		resolutionStrings.append(resolutionString)
	}
	
	return resolutionStrings
}
