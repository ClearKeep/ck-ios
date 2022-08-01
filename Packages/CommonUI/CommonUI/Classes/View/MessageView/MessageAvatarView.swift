//
//  MessageAvatarView.swift
//  
//
//  Created by NamNH on 20/03/2022.
//

import SwiftUI
import Kingfisher

private enum Constants {
}

public struct MessageAvatarView: View {
	// MARK: - Variables
	let userName: String
	let image: String
	var font: Font
	let avatarSize: CGSize
	let statusSize: CGSize?
	
	// MARK: - Init
	public init(avatarSize: CGSize,
		 statusSize: CGSize? = nil,
		 userName: String,
		 font: Font,
		 image: String) {
		self.avatarSize = avatarSize
		self.statusSize = statusSize
		self.userName = userName
		self.font = font
		self.image = image
	}
	
	// MARK: - Body
	public var body: some View {
		ZStack(alignment: .topTrailing) {
			Group {
				if let url = URL(string: self.image) {
					KFImage(url)
						.cacheOriginalImage()
						.setProcessor(DefaultImageProcessor())
						.resizable()
						.scaledToFill()
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
			.frame(width: avatarSize.width, height: avatarSize.height, alignment: .center)
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
