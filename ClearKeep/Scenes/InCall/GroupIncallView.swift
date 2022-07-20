//
//  GroupCallView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 19/05/2021.
//

import SwiftUI
import CommonUI
import ChatSecure

struct GroupIncallView: View {
    
    @ObservedObject var viewModel: CallViewModel
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                if viewModel.callType == .video {
                    VStack(spacing: 0) {
                        VideoContainerView(viewModel: viewModel)
                        CallVideoActionView(viewModel: viewModel)
                            .frame(height: 120)
                    }
                } else {
                    if viewModel.callStatus != .answered {
                        groupCallInfoView()
                    }
                    
                    CallVoiceActionView(viewModel: viewModel)
                }
            }
            .onAppear(perform: {
                print("#GroupCallView Reader size \(reader.size) \(reader.safeAreaInsets)")
            })
            .if(viewModel.callStatus == .answered, transform: { view in
                view.applyNavigationBarGradidentStyle(title: viewModel.getUserName(), leftBarItems: {
                    Button(action: {
                        viewModel.backHandler?()
                    }, label: {
                        Image("ic_back")
                            .frame(width: 24, height: 24, alignment: .leading)
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
                    })
                }, rightBarItems: {
                    Text(viewModel.timeCall)
						.font(AppTheme.shared.fontSet.font(style: .heading3))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
                })
            })
            .onAppear(perform: {
                if let callBox = CallManager.shared.calls.first {
                    viewModel.updateCallBox(callBox: callBox)
                }
            })
				.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.CallService.notification), perform: { (obj) in
                viewModel.didReceiveMessageGroup(userInfo: obj.userInfo)
            })
        }
    }
    
    private func groupCallInfoView() -> some View {
        VStack(spacing: 32) {
            Spacer()
                .frame(height: 60)
            
            VStack(spacing: 24) {
                Text(viewModel.getStatusMessage())
					.font(AppTheme.shared.fontSet.font(style: .placeholder1))
					.foregroundColor(AppTheme.shared.colorSet.grey5)
                
                if viewModel.callType == .audio {
                    Text(viewModel.getUserName())
						.font(AppTheme.shared.fontSet.font(style: .placeholder1))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
                }
            }
            
            Spacer()
        }
    }
}

struct GroupIncallView_Previews: PreviewProvider {
    static var previews: some View {
		GroupIncallView(viewModel: CallViewModel())
    }
}
