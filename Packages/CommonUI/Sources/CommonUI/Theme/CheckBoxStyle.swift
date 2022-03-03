//
//  SwiftUIView.swift
//  
//
//  Created by MinhDev on 23/02/2022.
//

import SwiftUI

struct CheckboxActive: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		return HStack {
			configuration.label
			Spacer()
			Image(systemName: configuration.isOn ? "checkmark.circle" : "circle.fill")
				.resizable()
				.foregroundColor(configuration.isOn ? Color(commonUIConfig.colorSet.primary) : Color(commonUIConfig.colorSet.gray3))
				.frame(width: 22, height: 22)
				.onTapGesture { configuration.isOn.toggle() }
		}
	}
}

struct CheckboxDisable: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		return HStack {
			configuration.label
			Spacer()
			Image(systemName: configuration.isOn ? "checkmark.circle" : "circle.fill")
				.resizable()
				.foregroundColor(configuration.isOn ? Color(commonUIConfig.colorSet.primaryLight) : Color(commonUIConfig.colorSet.gray4))
				.frame(width: 22, height: 22)
				.onTapGesture { configuration.isOn.toggle() }
		}
	}
}

