//
//  CameraSession.swift
//  GoogleWebRTCJanus
//
//  Created by VietAnh on 12/23/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol CameraSessionDelegate {
	func didOutput(_ sampleBuffer: CMSampleBuffer)
}

class CameraSession: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
	
	private var session: AVCaptureSession?
	private var output: AVCaptureVideoDataOutput?
	private var device: AVCaptureDevice?
	weak var delegate: CameraSessionDelegate?
	
	override init() {
		super.init()
	}
	
	func setupSession(position: AVCaptureDevice.Position = .front) {
		if let session = session { session.stopRunning() }
		session = AVCaptureSession()
		session?.sessionPreset = position  == .front ? AVCaptureSession.Preset.medium : AVCaptureSession.Preset.hd1920x1080
		device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
		guard let device = device,
			  let input = try? AVCaptureDeviceInput(device: device) else {
				  print("Caught exception!")
				  return
			  }
		
		session?.addInput(input)
		
		output = AVCaptureVideoDataOutput()
		let queue: DispatchQueue = DispatchQueue(label: "videodata", attributes: .concurrent)
		output?.setSampleBufferDelegate(self, queue: queue)
		output?.alwaysDiscardsLateVideoFrames = false
		output?.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] as [String: Any]
		
		guard let output = output else { return }
		session?.addOutput(output)
		session?.sessionPreset = AVCaptureSession.Preset.inputPriority
		session?.usesApplicationAudioSession = false
		session?.startRunning()
	}
	
	func stopSession() {
		session?.stopRunning()
	}
	
	func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		
	}
	
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		self.delegate?.didOutput(sampleBuffer)
	}
}
