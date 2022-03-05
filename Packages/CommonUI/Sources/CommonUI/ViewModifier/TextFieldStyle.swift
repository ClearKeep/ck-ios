//
//  TextFieldStyle.swift
//  
//
//  Created by NamNH on 03/03/2022.
//

import SwiftUI
import UIKit

public struct NormalTextField: ViewModifier {
	var roundedCornes: CGFloat
	@Binding var focused: Bool
	@Environment(\.colorScheme) var colorScheme

	public func body(content: Content) -> some View {
		HStack {
			commonUIConfig.imageSet.mailIcon
				.padding(.leading)
			content
				.foregroundColor(colorScheme == .light ? commonUIConfig.colorSet.black : commonUIConfig.colorSet.grey3)

				.padding(.leading, 10)
		}
		
		.background(commonUIConfig.colorSet.offWhite)
		.frame(width: UIScreen.main.bounds.width * 0.75, height: 52)
		.overlay(RoundedRectangle(cornerRadius: roundedCornes)
					.stroke(colorScheme == .light ? commonUIConfig.colorSet.primaryDefault : commonUIConfig.colorSet.primaryDefault, lineWidth: 1))
	}
}
