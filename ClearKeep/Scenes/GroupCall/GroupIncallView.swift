//
//  GroupCallView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 19/05/2021.
//

import SwiftUI
import CommonUI
import ChatSecure
import Combine
import Common
import Model

struct GroupIncallView: View {
    @ObservedObject var viewModel: CallViewModel
    
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isLoading: Bool = false
	@State private var isShowError: Bool = false
	@State private var error: LoginViewError?
	
	@State private(set) var loadable: Loadable<IPeerViewModels> = .notRequested {
		didSet {
			switch loadable {
			case .loaded(let load):
				isLoading = false
				if let changeCallVideo = load.callVideoModel {
					if changeCallVideo.error.isEmptyOrNil {
						self.viewModel.updateCallTypeVideo()
					}
				}
			case .failed(let error):
				isLoading = false
				self.error = LoginViewError(error)
				self.isShowError = true
			case .isLoading:
				isLoading = true
			default: break
			}
		}
	}
	
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
                    
					CallVoiceActionView(viewModel: viewModel, callAction: changeCallToVideo(type:))
                }
            }
            .onAppear(perform: {
                print("#GroupCallView Reader size \(reader.size) \(reader.safeAreaInsets)")
            })
            .if(viewModel.callStatus == .answered, transform: { view in
                view.applyNavigationBarGradidentStyle(title: viewModel.getUserName(),
													  leftBarItems: {
                    Button(action: {
                        viewModel.backHandler?()
                    }, label: {
						AppTheme.shared.imageSet.chevleftIcon
                            .frame(width: 30, height: 30, alignment: .leading)
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
		.progressHUD(isLoading)
		.alert(isPresented: $isShowError) {
			Alert(title: Text(self.error?.title ?? ""),
				  message: Text(self.error?.message ?? ""),
				  dismissButton: .default(Text(error?.primaryButtonTitle ?? "")))
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


private extension GroupIncallView {
	func changeCallToVideo(type: CallType) {
		guard let callBox = self.viewModel.callBox else { return }
		self.loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			self.loadable = await injected.interactors.peerCallInteractor.updateVideoCall(groupID: callBox.roomId, callType: type)
		}
	}
}
