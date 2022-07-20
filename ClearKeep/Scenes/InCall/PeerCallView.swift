//
//  PeerCallView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 18/05/2021.
//

import SwiftUI
import CommonUI
import ChatSecure

struct PeerCallView: View {
    @ObservedObject var viewModel: CallViewModel
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                Image("bg_call")
                    .resizable()
                    .frame(width: reader.frame(in: .global).width, height: reader.frame(in: .global).height, alignment: .center)
                    .blur(radius: 70)
                    
                if viewModel.callType == .video {
                    VStack(spacing: 0) {
                        VideoContainerView(viewModel: viewModel)
                        CallVideoActionView(viewModel: viewModel)
                            .frame(height: 120)
                    }
                    .edgesIgnoringSafeArea(.all)

                    SingleVideoCallInfoView(viewModel: viewModel)
                } else {
                    CallVoiceActionView(viewModel: viewModel)
                    SingleVoiceCallInfoView(viewModel: viewModel)
                }
				
				Button(action: customBack) {
					HStack {
						AppTheme.shared.imageSet.chevleftIcon
							.aspectRatio(contentMode: .fit)
					}
					.frame(maxWidth: .infinity, alignment: .leading)
					.frame(height: 30)
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.padding(.top, 60)
				.padding(.horizontal, 30)
            }
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
}

private extension PeerCallView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

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
    
struct PeerCallView_Previews: PreviewProvider {
    static var previews: some View {
        PeerCallView(viewModel: CallViewModel())
    }
}

struct SingleVoiceCallInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SingleVoiceCallInfoView(viewModel: CallViewModel())
    }
}
