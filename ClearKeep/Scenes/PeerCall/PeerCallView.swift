//
//  PeerCallView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 18/05/2021.
//

import SwiftUI
import CommonUI
import ChatSecure
import Combine
import Common
import Model
import CallManager

struct PeerCallView: View {
	@ObservedObject var viewModel: CallViewModel
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private var isLoading: Bool = false
	@State private var isShowError: Bool = false
	@State private var alertType: InCallView.AlertCall = .changeTypeCall
	
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
				self.alertType = .error(error: LoginViewError(error))
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
				if let avatar = viewModel.callBox?.avatar {
					AsyncImage(url: URL(string: avatar)) { image in
								// 1
								image
									.resizable()
									.scaledToFill()
							} placeholder: {
								// 2
								Color.red.opacity(0.5)
							}
							.frame(width: reader.frame(in: .global).width, height: reader.frame(in: .global).height, alignment: .center)
							.blur(radius: 70)
				} else {
					Image("bg_call")
						.resizable()
						.frame(width: reader.frame(in: .global).width, height: reader.frame(in: .global).height, alignment: .center)
						.blur(radius: 70)
				}
				
				if viewModel.callType == .video {
					VStack(spacing: 0) {
						VideoContainerView(viewModel: viewModel)
						CallVideoActionView(viewModel: viewModel)
							.frame(height: 120)
					}
					.edgesIgnoringSafeArea(.all)
					
					SingleVideoCallInfoView(viewModel: viewModel)
				} else {
					CallVoiceActionView(viewModel: viewModel,
										callAction: {
						if viewModel.callType == .video {
							self.changeCallToVideo(type: .audio)
							return
						}
						
						self.changeCallToVideo(type: .video)
					},
										endCall: {
						self.alertType = .endCall
						self.isShowError = true
					})
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
			.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.CallService.notification), perform: { (obj) in
				viewModel.didReceiveMessageGroup(userInfo: obj.userInfo)
			})
		}
		.progressHUD(isLoading)
		.alert(isPresented: $isShowError) {
			if case .error = self.alertType {
				return Alert(title: Text(self.alertType.title),
							 message: Text(self.alertType.description),
							 dismissButton: .default(Text(self.alertType.primaryButtonTitle)))
				
			}
			
			return Alert(title: Text(self.alertType.title),
						 message: Text(self.alertType.description),
						 primaryButton: .default(Text(self.alertType.primaryButtonTitle), action: {
				switch self.alertType {
				case .changeTypeCall:
					if viewModel.callType == .video {
						self.viewModel.cameraOn = true
						self.viewModel.callBox?.isCamera = true
						self.viewModel.callBox?.videoRoom?.publisher?.cameraOn()
						return
					}
					
				case .endCall:
					viewModel.endCall()
				default:
					break
				}
			}),
						 secondaryButton: .cancel(Text(self.alertType.secondButtonTitle)))
		}
		.onReceive(NotificationCenter.default.publisher(for: Notification.Name.CallService.changeTypeCall)) { (obj) in
			guard let data = obj.object as? PublicationNotification,
				  data.notifyType == "video" && self.viewModel.callType == .audio else {
				return
			}
			self.viewModel.updateCallType(data: data)
			self.alertType = .changeTypeCall
			self.isShowError = true
		}
		.onReceive(NotificationCenter.default.publisher(for: Notification.Name.CallService.changeStatusBusyCall)) { _ in
			self.viewModel.callStatus = .busy
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.viewModel.endCallAndDismiss()
			}
		}
	}
}

private extension PeerCallView {
	func customBack() {
		viewModel.backHandler?()
	}
}

private extension PeerCallView {
	func changeCallToVideo(type: CallType) {
		guard let callBox = self.viewModel.callBox else { return }
		self.loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			self.loadable = await injected.interactors.peerCallInteractor.updateVideoCall(groupID: callBox.roomRtcId, callType: type)
		}
	}
}
