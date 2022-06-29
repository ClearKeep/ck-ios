//
//  DetailType.swift
//  ClearKeep
//
//  Created by MinhDev on 24/06/2022.
//

import SwiftUI

enum DetailType: String, CaseIterable, Identifiable, RawRepresentable {
	var id: String { self.rawValue }
	case seeMember
	case addMember
	case removeMember
	case leaveGroup

	var title: String {
		switch self {
		case .seeMember:
			return "GroupDetail.SeeMembers".localized
		case .addMember:
			return "GroupDetail.AddMember".localized
		case .removeMember:
			return "GroupDetail.RemoveMember".localized
		case .leaveGroup:
			return "GroupDetail.LeaveGroup".localized
		}
	}

	var icon: Image {
		switch self {
		case .seeMember:
			return AppTheme.shared.imageSet.userIcon
		case .addMember:
			return AppTheme.shared.imageSet.usersPlusIcon
		case .removeMember:
			return AppTheme.shared.imageSet.userOfflineIcon
		case .leaveGroup:
			return AppTheme.shared.imageSet.logoutIcon
		}
	}

	var color: Color {
		switch self {
		case .seeMember:
			return AppTheme.shared.colorSet.grey1
		case .addMember:
			return AppTheme.shared.colorSet.grey1
		case .removeMember:
			return AppTheme.shared.colorSet.grey1
		case .leaveGroup:
			return AppTheme.shared.colorSet.errorDefault
		}
	}
}
