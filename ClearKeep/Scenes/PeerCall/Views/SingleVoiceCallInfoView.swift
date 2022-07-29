//
//  SingleVoiceCallInfoView.swift
//  ClearKeep
//
//  Created by HOANDHTB on 25/07/2022.
//

import SwiftUI
import CommonUI

struct SingleVoiceCallInfoView: View {
	@ObservedObject var viewModel: CallViewModel
	
	func image(withName: String?) -> Image? {
		guard let name = withName, !name.isEmpty else {
			return nil
		}
		return Image(name)
	}
	
	var body: some View {
		GeometryReader { reader in
			VStack {
				Spacer()
				
				VStack(spacing: 32) {
					Spacer()
						.frame(height: 60)
					
					if viewModel.callType == .audio, viewModel.callStatus != .answered, !viewModel.getStatusMessage().isEmpty {
						Text(viewModel.getStatusMessage())
							.font(AppTheme.shared.fontSet.font(style: .input2))
							.foregroundColor(AppTheme.shared.colorSet.grey5)
					}
					AvatarDefault(.constant(viewModel.getUserName()), imageUrl: viewModel.callBox?.avatar ?? "")
						.font(Font.system(size: 72))
						.frame(width: 160, height: 160)
					
					VStack(spacing: 8) {
						Text(viewModel.getUserName())
							.font(AppTheme.shared.fontSet.font(style: .display2))
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
							.lineLimit(2)
							.padding(.horizontal, 16)
							.layoutPriority(1)
						
						if viewModel.callType == .audio, viewModel.callStatus == .answered {
							Text(viewModel.timeCall)
								.font(AppTheme.shared.fontSet.font(style: .heading3))
								.foregroundColor(AppTheme.shared.colorSet.offWhite)
						}
					}
					
					Spacer()
					
					Spacer()
						.frame(height: reader.size.height/2)
				}
				
				Spacer()
			}
			.frame(width: reader.size.width, height: reader.size.height)
		}
		
		.edgesIgnoringSafeArea(.top)
	}
}
