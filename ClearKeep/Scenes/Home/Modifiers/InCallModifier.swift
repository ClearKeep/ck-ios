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
var callController: UIViewController?

struct InCallModifier: ViewModifier {
	@State var isInMinimizeMode: Bool = false
	
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@Binding var isInCall: Bool
	@ObservedObject var callViewModel: CallViewModel
	@State private var location: CGPoint = Position.bottomTrailling.location
	@GestureState private var startLocation: CGPoint? = nil // 1
	
	var simpleDrag: some Gesture {
		DragGesture()
			.onChanged { value in
				var newLocation = startLocation ?? location // 3
				newLocation.x += value.translation.width
				newLocation.y += value.translation.height
				self.location = newLocation
			}.updating($startLocation) { (_, startLocation, _) in
				startLocation = startLocation ?? location // 2
			}
			.onEnded({ _ in
				self.location = self.getPosition(position: self.location).location
			})
		
	}
	
	func body(content: Content) -> some View {
		ZStack(alignment: .topLeading) {
			VStack {
				content
			}
			if isInCall && isInMinimizeMode {
				mimimumView
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.CallService.receiveCall)) { _ in
			callViewModel.backHandler = {
				callController?.dismiss(animated: true)
				
				withAnimation {
					isInCall = true
					isInMinimizeMode = true
				}
			}
			
			self.callViewModel.timeCounter.sec = 0
			self.callViewModel.timeCounter.min = 0
			self.callViewModel.timeCounter.hour = 0
			self.callViewModel.callInterval = 0
			let viewController = UIHostingController(rootView: InCallView(viewModel: callViewModel))
			callController = viewController
			viewController.modalPresentationStyle = .overFullScreen
			let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
			sceneDelegate?.window?.rootViewController?.present(viewController, animated: true)
		}
		.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name.CallService.endCall)) { _ in
			isInCall = false
			isInMinimizeMode = false
			self.callViewModel.speakerEnable = false
			self.callViewModel.microEnable = true
			self.callViewModel.cameraFront = false
			self.callViewModel.localVideoView = nil
			self.callViewModel.remoteVideoView = nil
			self.callViewModel.remotesVideoView.removeAll()
			if var topController = UIApplication.shared.keyWindow?.rootViewController {
				while let presentedViewController = topController.presentedViewController {
					topController = presentedViewController
				}

				topController.dismiss(animated: true)
			}
		}
	}
	
	var mimimumView: some View {
		VStack {
			HStack(alignment: .top) {
				Spacer()
				if callViewModel.callBox?.isCallGroup ?? false {
					ZStack {
						LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
							.frame(maxWidth: .infinity, maxHeight: .infinity)

						VStack {
							Text(callViewModel.getUserName())
								.font(AppTheme.shared.fontSet.font(style: .body2))
								.foregroundColor(.white)
								.frame(maxWidth: .infinity)
								.padding(10)
						}
					}
					
				} else if callViewModel.callType == .video && callViewModel.cameraOn, let videoView = callViewModel.localVideoView {
					VideoView(rtcVideoView: videoView)
				} else {
					ZStack {
						if let avatar = callViewModel.callBox?.avatar,
						   !avatar.isEmpty {
							AsyncImage(url: URL(string: avatar)) { image in
								// 1
								image
									.resizable()
									.scaledToFill()
							} placeholder: {
								// 2
								Color.red.opacity(0.5)
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.blur(radius: 5)
						} else {
							LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
								.frame(maxWidth: .infinity, maxHeight: .infinity)
						}
						
						VStack {
							if !(callViewModel.callBox?.isCallGroup ?? false) {
								AvatarDefault(.constant(callViewModel.getUserName()), imageUrl: callViewModel.getAvatar())
									.frame(width: 90, height: 90)
							}
							
							Text(callViewModel.getUserName())
								.font(AppTheme.shared.fontSet.font(style: .body2))
								.foregroundColor(.white)
								.frame(maxWidth: .infinity)
								.padding(10)
						}
						
					}
				}
				
			}
		}
			.onTapGesture {
				callViewModel.backHandler = {
					callController?.dismiss(animated: true)
					withAnimation {
						isInMinimizeMode = true
						isInCall = true
					}
				}
				
				isInMinimizeMode = false
				
				let viewController = UIHostingController(rootView: InCallView(viewModel: callViewModel))
				viewController.modalPresentationStyle = .overFullScreen
				callController = viewController
				let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
				sceneDelegate?.window?.rootViewController?.present(viewController, animated: true)
			}
			.transition(.move(edge: .top))
			.frame(width: 150,
				   height: 225,
				   alignment: .center)
			.clipShape(Rectangle())
			.padding(.trailing, 16)
			.padding(.bottom, 68)
			.animation(.easeInOut(duration: 0.6))
			.position(self.location)
			.gesture(simpleDrag)
	}
}

extension View {
	func inCallModifier(callViewModel: CallViewModel, isInCall: Binding<Bool>) -> some View {
		self.modifier(InCallModifier(isInCall: isInCall, callViewModel: callViewModel))
	}
}

extension InCallModifier {
	private func getPosition(position: CGPoint) -> Position {
		let size = UIScreen.main.bounds.size
		let width = size.width
		let height = size.height
		
		if position.x <= width / 2 && position.y <= height / 2 {
			return .topLeading
		}
		
		if position.x > width / 2 && position.y <= height / 2 {
			return .topTrailling
		}
		
		if position.x <= width / 2 && position.y > height / 2 {
			return .bottomLeading
		}
		
		return .bottomTrailling
	}
	
	enum Position {
		case topLeading
		case topTrailling
		case bottomTrailling
		case bottomLeading
		
		var location: CGPoint {
			let size = UIScreen.main.bounds.size
			let width = size.width
			let height = size.height
			
			switch self {
			case .topLeading:
				return CGPoint(x: 100, y: 150)
			case .topTrailling:
				return CGPoint(x: width - 100, y: 150)
			case .bottomLeading:
				return CGPoint(x: 100, y: height - 180)
			case .bottomTrailling:
				return CGPoint(x: width - 100, y: height - 180)
			}
		}
	}
}
