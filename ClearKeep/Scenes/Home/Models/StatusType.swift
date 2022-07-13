//
//  StatusType.swift
//  ClearKeep
//
//  Created by NamNH on 16/05/2022.
//

import SwiftUI

enum StatusType: String, Equatable, CaseIterable {
	case online = "Online"
	case ofline = "Offline"
	case busy = "Busy"
	case undefined = "Undefined"
	
	var title: String {
		switch self {
		case .online:
			return "Status.Online.Title".localized
		case .busy:
			return "Status.Busy.Title".localized
		case .ofline:
			return "Status.Offline.Title".localized
		case .undefined:
			return "Status.Busy.Title".localized
		}
	}
	
	var color: Color {
		switch self {
		case .online:
			return AppTheme.shared.colorSet.successDefault
		case .busy:
			return AppTheme.shared.colorSet.errorDefault
		case .ofline:
			return AppTheme.shared.colorSet.darkgrey3
		case .undefined:
			return AppTheme.shared.colorSet.errorDefault
		}
	}
	
	var image: Image {
		let image = Image("")
		image.frame(width: 10, height: 10, alignment: .center)
		image.background(self.color)
		return image
	}
}
