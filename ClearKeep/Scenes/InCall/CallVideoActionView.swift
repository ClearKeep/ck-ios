//
//  CallActionBottomView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 18/05/2021.
//

import SwiftUI

struct CallVideoActionView: View {
    @ObservedObject var viewModel: CallViewModel

    var body: some View {
        GeometryReader { reader in
            VStack {
                HStack(spacing: 12) {
                    Spacer()
                    CallActionButtonView(onIcon: AppTheme.shared.imageSet.muteIcon, offIcon: AppTheme.shared.imageSet.muteOffIcon, isOn: viewModel.microEnable, action: viewModel.microChange)
                    Spacer()
                    CallActionButtonView(onIcon: AppTheme.shared.imageSet.videoIcon, offIcon: AppTheme.shared.imageSet.videoOffIcon, isOn: viewModel.cameraOn, action: viewModel.cameraChange)
                    Spacer()
                    CallActionButtonView(onIcon: AppTheme.shared.imageSet.cameraRolateIcon, offIcon: AppTheme.shared.imageSet.cameraRolateIcon, isOn: viewModel.cameraFront, action: viewModel.cameraSwipeChange)
                    Spacer()
                    CallActionButtonView(onIcon: AppTheme.shared.imageSet.phoneOffIcon, offIcon: AppTheme.shared.imageSet.phoneOffIcon, isOn: true, styleButton: .endCall, action: {
                        viewModel.endCall()
                        // isShowCall = false
                    })
                    Spacer()
                }
            }
            .frame(width: reader.size.width)
            .padding(.vertical, 16)
            .padding(.bottom, 28)
			.background(AppTheme.shared.colorSet.grey4)
        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CallActionBottomView_Previews: PreviewProvider {
    static var previews: some View {
        CallVideoActionView(viewModel: CallViewModel())
    }
}
