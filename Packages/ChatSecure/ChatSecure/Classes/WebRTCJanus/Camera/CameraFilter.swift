//
//  CameraFilter.swift
//  GoogleWebRTCJanus
//
//  Created by VietAnh on 12/23/20.
//  Copyright © 2020 Vmodev. All rights reserved.
//

import Foundation
import AVFoundation
import CoreImage

enum FilterType: Int {
	case none
	case sepia
	case monochrome
	case colorControls
	
	mutating func next() -> FilterType {
		return FilterType(rawValue: rawValue + 1) ?? .none
	}
}

class CameraFilter {
	private var filter: CIFilter
	private let context: CIContext
	var filterType: FilterType = .none
	
	init() {
		filter = CIFilter()
		context = CIContext()
	}
	
	func apply(_ sampleBuffer: CVPixelBuffer) -> CVPixelBuffer? {
		if filterType == .none { return sampleBuffer }
		
		let ciimage = CIImage(cvPixelBuffer: sampleBuffer)
		let size: CGSize = ciimage.extent.size
		self.filter.setValue(ciimage, forKey: kCIInputImageKey)
		
		let filtered = filter.outputImage
		var pixelBuffer: CVPixelBuffer?
		
		let options = [
			kCVPixelBufferCGImageCompatibilityKey as String: kCFBooleanTrue as Any,
			kCVPixelBufferCGBitmapContextCompatibilityKey as String: kCFBooleanTrue as Any
		] as [String: Any]
		
		let status: CVReturn = CVPixelBufferCreate(kCFAllocatorDefault,
												   Int(size.width),
												   Int(size.height),
												   kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
												   options as CFDictionary?,
												   &pixelBuffer)
		
		if let filtered = filtered, let pixelBuffer = pixelBuffer, status == kCVReturnSuccess {
			context.render(filtered, to: pixelBuffer)
		}
		return pixelBuffer
	}
	
	func changeFilter(_ filterType: FilterType) {
		switch filterType {
		case .sepia:
			filter = CIFilter(name: "CISepiaTone") ?? CIFilter()
			filter.setValue(0.8, forKey: "inputIntensity")
		case .monochrome:
			filter = CIFilter(name: "CIColorMonochrome") ?? CIFilter()
			filter.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: "inputColor")
			filter.setValue(1.0, forKey: "inputIntensity")
		case .colorControls:
			filter = CIFilter(name: "CIColorControls" ) ?? CIFilter()
			filter.setValue(1.0, forKey: "inputSaturation")
			filter.setValue(0.5, forKey: "inputBrightness")
			filter.setValue(3.0, forKey: "inputContrast")
		case .none:
			break
		}
		self.filterType = filterType
	}
}
