//
//  MenuType.swift
//  ClearKeep
//
//  Created by NamNH on 12/05/2022.
//

import SwiftUI

enum MenuType: String, CaseIterable, Identifiable, RawRepresentable {
	var id: String { self.rawValue }
	case profile
	case server
	case notification

	var title: String {
		switch self {
		case .profile:
			return "Menu.Profile.Title".localized
		case .server:
			return "Menu.Server.Title".localized
		case .notification:
			return "Menu.Notification.Title".localized
		}
	}
	
	var icon: Image {
		switch self {
		case .profile:
			return AppTheme.shared.imageSet.userIcon
		case .server:
			return AppTheme.shared.imageSet.serverIcon
		case .notification:
			return AppTheme.shared.imageSet.notificationIcon
		}
	}
}
