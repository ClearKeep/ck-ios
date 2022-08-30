//
//  GroupCallView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 19/05/2021.
//

import SwiftUI
import CommonUI
import CallManager
import Combine
import Common
import Model

struct GroupIncallView: View {
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
						self.viewModel.callBox?.videoRoom?.publisher?.cameraOn()
						self.viewModel.callBox?.isCamera = true
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
			self.loadable = await injected.interactors.peerCallInteractor.updateVideoCall(groupID: callBox.roomRtcId, callType: type)
		}
	}
}
