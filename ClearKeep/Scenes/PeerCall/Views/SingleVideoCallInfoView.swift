//
//  SingleVideoCallInfoView.swift
//  ClearKeep
//
//  Created by HOANDHTB on 25/07/2022.
//

import SwiftUI

struct SingleVideoCallInfoView: View {
	@ObservedObject var viewModel: CallViewModel
	
	var body: some View {
		VStack(spacing: 32) {
			Spacer()
				.frame(height: 60)
			
			if viewModel.callStatus != .answered {
				Text(viewModel.getStatusMessage())
					.font(AppTheme.shared.fontSet.font(style: .input2))
					.foregroundColor(AppTheme.shared.colorSet.grey5)
				
				Text(viewModel.getUserName())
					.font(AppTheme.shared.fontSet.font(style: .display2))
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
					.lineLimit(2)
					.padding(.horizontal, 16)
			} else {
				HStack(alignment: .top, spacing: 0) {
					Button(action: {
						viewModel.backHandler?()
					}, label: {
						Image("ic_back")
							.frame(width: 24, height: 24, alignment: .leading)
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					})
					.padding(.all, 8)
					.padding(.leading, 8)
					
					VStack(alignment: .leading, spacing: 8) {
						Text(viewModel.getUserName())
							.font(AppTheme.shared.fontSet.font(style: .display2))
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
						
						Text(viewModel.timeCall)
							.font(AppTheme.shared.fontSet.font(style: .display3))
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					}
					
					Spacer()
				}
				
			}

			Spacer()
		}
		.edgesIgnoringSafeArea(.top)
	}
}
