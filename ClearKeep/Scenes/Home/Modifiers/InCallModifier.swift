//
//  InCallModifier.swift
//  ClearKeep
//
//  Created by HOANDHTB on 19/07/2022.
//

import UIKit
import SwiftUI
import CommonUI
import ChatSecure

struct InCallModifier: ViewModifier {
	@State var isInMinimizeMode: Bool = false
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@Binding var isInCall: Bool
	@ObservedObject var callViewModel: CallViewModel
	
	func body(content: Content) -> some View {
		ZStack(alignment: .topLeading) {
			VStack {
				if isInCall {
					Spacer()
				}
				content
			}
			if isInCall {
				HStack(alignment: .bottom) {
					if !callViewModel.callGroup {
						AvatarDefault(.constant(callViewModel.getUserName()), imageUrl: "")
							.frame(width: 34, height: 34)
							.padding(.trailing, 16)
							.padding(.leading, 24)
					}
					VStack(alignment: .leading) {
						Spacer()
						Text(callViewModel.getUserName())
							.font(AppTheme.shared.fontSet.font(style: .body2))
							.foregroundColor(AppTheme.shared.colorSet.grey5)
							.lineLimit(1)
						Text("Tap here to return to call screen")
							.font(AppTheme.shared.fontSet.font(style: .placeholder3))
							.foregroundColor(AppTheme.shared.colorSet.background)
							.lineLimit(1)
					}
					Spacer()
					Text(callViewModel.timeCall)
						.font(AppTheme.shared.fontSet.font(style: .placeholder3))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
						.lineLimit(1)
						.padding(.trailing, 24)
				}
				.padding(.bottom, 16)
				.frame(height: globalSafeAreaInsets().top + 50)
				.background(RoundedCorner(radius: 20, rectCorner: [.bottomLeft, .bottomRight]).fill(AppTheme.shared.colorSet.successDefault))
				.edgesIgnoringSafeArea(.all)
				.onTapGesture {
					callViewModel.backHandler = {
						NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissModal"), object: nil)
						withAnimation {
							isInMinimizeMode = true
							isInCall = true
						}
					}
					
					isInMinimizeMode = false
					
					let viewController = UIHostingController(rootView: InCallView(viewModel: callViewModel))
					viewController.modalPresentationStyle = .overFullScreen
					let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
					sceneDelegate?.window?.rootViewController?.present(viewController, animated: true)
				}
				.transition(.move(edge: .top))
				
				if isInMinimizeMode {
					VStack {
						Spacer()
						HStack(alignment: .top) {
							Spacer()
							if let videoView = callViewModel.remoteVideoView {
								VideoView(rtcVideoView: videoView)
									.frame(width: 120,
										   height: 180,
										   alignment: .center)
									.background(Color.black)
									.clipShape(Rectangle())
									.cornerRadius(10)
									.padding(.trailing, 16)
									.padding(.bottom, 68)
									.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
									.animation(.easeInOut(duration: 0.6))
							}
						}
					}.padding(.trailing, 16)
				}
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.CallService.receiveCall)) { _ in
			callViewModel.backHandler = {
				NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissModal"), object: nil)
				
				withAnimation {
					isInCall = true
					isInMinimizeMode = true
				}
			}
			let viewController = UIHostingController(rootView: InCallView(viewModel: callViewModel))
			viewController.modalPresentationStyle = .overFullScreen
			let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
			sceneDelegate?.window?.rootViewController?.present(viewController, animated: true)
		}
		.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.CallService.endCall)) { _ in
			withAnimation {
				isInCall = false
				isInMinimizeMode = false
			}
			NotificationCenter.default.post(name: Notification.Name(rawValue: "dismissModal"), object: nil)
		}
	}
}

extension View {
	func inCallModifier(callViewModel: CallViewModel, isInCall: Binding<Bool>) -> some View {
		self.modifier(InCallModifier(isInCall: isInCall, callViewModel: callViewModel))
	}
}
