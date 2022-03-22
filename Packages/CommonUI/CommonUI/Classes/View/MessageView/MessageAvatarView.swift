//
//  MessageAvatarView.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI

private enum Constants {
}

struct MessageAvatarView: View {
	// MARK: - Variables
	let userName: String
	let image: Image?
	var font: Font
	let avatarSize: CGSize
	let statusSize: CGSize
	
	// MARK: - Init
	init(avatarSize: CGSize,
		 statusSize: CGSize,
		 userName: String,
		 font: Font,
		 image: Image? = nil) {
		self.avatarSize = avatarSize
		self.statusSize = statusSize
		self.userName = userName
		self.font = font
		self.image = image
	}
	
	// MARK: - Body
	var body: some View {
		ZStack(alignment: .topTrailing) {
			Group {
				if let loadedImage = image {
					loadedImage
						.resizable()
						.scaledToFill()
						.frame(width: avatarSize.width, height: avatarSize.height, alignment: .center)
				} else {
					ZStack(alignment: .center) {
						LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientAccent), startPoint: .leading, endPoint: .trailing)
							.frame(width: avatarSize.width, height: avatarSize.height, alignment: .center)
						
						Text(userName.first?.uppercased() ?? "")
							.font(font)
							.frame(alignment: .center)
							.foregroundColor(Color.primary)
							.colorInvert()
					}
				}
			}
			.clipShape(Circle())
			
//			Group {
//				switch status {
//				case .active: AppTheme.colors.success.color
//				case .away: AppTheme.colors.gray3.color
//				case .doNotDisturb: AppTheme.colors.error.color
//				case .invisible: AppTheme.colors.gray3.color
//				case .none: Color.clear
//				}
//			}
//			.frame(width: statusSize.width, height: statusSize.height)
//			.clipShape(Circle())
		}
	}
}
