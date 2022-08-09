//
//  GroupDetailContent.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import SwiftUI
import Common
import CommonUI
import ChatSecure
import AVFoundation

private enum Constants {
	static let padding = 20.0
	static let paddingTralling = 60.0
	static let paddingHorizontal = 61.75
	static let paddingVertical = 14.0
	static let spaceHstack = -10.0
	static let imageSize = CGSize(width: 36.0, height: 36.0)
	static let itemHeight = 32.0
}

struct DetailContentView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var loadable: Loadable<IGroupDetailViewModels>
	@Binding var groupData: GroupDetailViewModel?
	@Binding var member: [GroupDetailClientViewModel]
	@State private var messageAlert: String = ""
	@State private var isShowAlert: Bool = false
	@State private var errorType: ErrorType = .error
	@State private var hudVisible = false
	@State private var disableCall = false
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		VStack {
			if member.count < 5 {
				HStack(spacing: Constants.spaceHstack) {
					Spacer()
					ForEach(0..<member.prefix(4).count, id: \.self) { user in
						AvatarDefault(.constant(member[user].userName), imageUrl: member[user].avatar)
							.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
					}
					Spacer()
				}
			} else {
				HStack(spacing: Constants.spaceHstack) {
					Spacer()
					ForEach(0..<member.prefix(4).count, id: \.self) { user in
						AvatarDefault(.constant(member[user].userName), imageUrl: member[user].avatar)
							.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
					}
					ZStack {
						Circle()
							.fill(foregroundButtonImage)
							.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
						Text("+\(member.count - 4)")
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					}
					Spacer()
				}
			}
			HStack(alignment: .center) {
				ImageButtonCircleCall("General.Audio".localized, image: AppTheme.shared.imageSet.phoneCallIcon, action: audioAction).disabled(self.disableCall)
				Spacer()
				ImageButtonCircleCall("General.Video".localized, image: AppTheme.shared.imageSet.videoIcon, action: videoAction).disabled(self.disableCall)
			}
			.padding(.horizontal, Constants.paddingHorizontal)
			.padding(.vertical, Constants.paddingVertical)
			ForEach(DetailType.allCases, id: \.self) { detail in
				LinkButton(detail.title, icon: detail.icon, alignment: .leading) { didSelect(detail) }
				.foregroundColor(detail.color)
				.frame(height: Constants.itemHeight)
			}

			Spacer()
		}
		.padding(.horizontal, Constants.padding)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.applyNavigationBarPlainStyle(title: groupData?.groupName
									  ?? "Name",
									  titleColor: titleColor,
									  backgroundColors: backgroundButtonBack,
									  leftBarItems: {
			BackButtonStandard(customBack)
		},
									  rightBarItems: {
			Spacer()
		})
		.alert(isPresented: self.$isShowAlert) {
			switch self.errorType {
			case .error:
				return Alert(title: Text("GroupChat.Warning".localized),
							 message: Text(self.messageAlert),
					dismissButton: .default(Text("GroupChat.Ok".localized)))
			case .permission:
				return Alert(title: Text("Call.PermistionCall".localized),
					  message: Text("Call.GoToSetting".localized),
					  primaryButton: .default(Text("Call.Settings".localized), action: {
					guard let url = URL(string: UIApplication.openSettingsURLString) else {
						return
					}
					UIApplication.shared.open(url)
				}),
					  secondaryButton: .default(Text("Call.Cancel".localized)))
			case .existCall:
				return Alert(title: Text("General.Warning".localized),
							 message: Text("Call.HaveExistCall".localized),
						  dismissButton: .default(Text("General.OK".localized)))
			}
			
		}
		.progressHUD(hudVisible)
	}
}

// MARK: - Private
private extension DetailContentView {
	enum ErrorType {
		case error
		case permission
		case existCall
	}
}

// MARK: - Private Variables
private extension DetailContentView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}

	var foregroundButtonImage: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientLinear), startPoint: .leading, endPoint: .trailing)
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.background, AppTheme.shared.colorSet.background] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension DetailContentView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}

	func audioAction() {
		self.call(callType: .audio)
	}

	func videoAction() {
		self.call(callType: .video)
	}

	func didSelect(_ detail: DetailType) {
		switch detail {
		case .seeMember:
			Task {
				loadable = await injected.interactors.groupDetailInteractor.getClientInGroup(by: groupData?.groupId ?? 0)
			}
		case .addMember:
			Task {
				loadable = await injected.interactors.groupDetailInteractor.getProfile()
			}
		case .removeMember:
			Task {
				loadable = await injected.interactors.groupDetailInteractor.lstMemberRemove(by: groupData?.groupId ?? 0)
			}
		case .leaveGroup:
			let user = member.filter { $0.id == DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "" }
			user.forEach { profile in
				Task {
					loadable = await injected.interactors.groupDetailInteractor.leaveGroup(profile, groupId: groupData?.groupId ?? 0)
				}
			}
		}
	}
	
	private func call(callType type: CallType) {
		if CallManager.shared.calls.count > 0 {
			self.errorType = .existCall
			self.isShowAlert = true
			self.disableCall = false
			return
		}
		
		AVCaptureDevice.authorizeVideo(completion: { (status) in
			AVCaptureDevice.authorizeAudio(completion: { (status) in
				if status == .alreadyAuthorized || status == .justAuthorized {
					hudVisible = true
					Task {
						let response = await self.injected.interactors.chatInteractor.requestVideoCall(isCallGroup: groupData?.groupType != "peer",
																									   clientId: DependencyResolver.shared.channelStorage.currentServer?.profile?.userId ?? "",
																									   clientName: self.groupData?.groupName ?? "",
																									   avatar: self.groupData?.groupAvatar ?? "",
																									   groupId: self.groupData?.groupId ?? 0,
																									   callType: type)
						switch response {
						case .success:
							hudVisible = false
							disableCall = false
						case .failure(let error):
							hudVisible = false
							disableCall = false
							print(error)
						}
					}
				} else {
					self.isShowAlert = true
					disableCall = false
				}
			})
		})
	}
}

// MARK: - Loading Content
private extension DetailContentView {

}

// MARK: - Interactor
private extension DetailContentView {
}

// MARK: - Preview
#if DEBUG
struct DetailContentView_Previews: PreviewProvider {
	static var previews: some View {
		DetailContentView(loadable: .constant(.notRequested), groupData: .constant(nil), member: .constant([]))
	}
}
#endif
