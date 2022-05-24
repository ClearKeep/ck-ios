//
//  StatusType.swift
//  ClearKeep
//
//  Created by NamNH on 16/05/2022.
//

import SwiftUI

enum StatusType: Equatable, CaseIterable {
	case online
	case busy
	
	var title: String {
		switch self {
		case .online:
			return "Status.Online.Title".localized
		case .busy:
			return "Status.Busy.Title".localized
		}
	}
	
	var color: Color {
		switch self {
		case .online:
			return AppTheme.shared.colorSet.successDefault
		case .busy:
			return AppTheme.shared.colorSet.errorDefault
		}
	}
}
