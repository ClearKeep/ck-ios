//
//  GroupDetailContent.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let padding = 20.0
	static let paddingTralling = 60.0
	static let paddingHorizontal = 61.75
	static let paddingVertical = 14.0
	static let frameList = CGSize(width: 120.0, height: 36.0)
	static let imageSize = CGSize(width: 36.0, height: 36.0)
	static let itemHeight = 32.0
	static let imageOffset = UIOffset(horizontal: -25.0, vertical: 25.0)
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
	@Binding var myProfile: GroupDetailUserViewModels?
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		VStack {
			ZStack(alignment: .center, content: {
				if member.count > 3 {
					ZStack {
						Circle()
							.fill(foregroundButtonImage)
							.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
						Text("+\(member.count - 4)")
							.font(AppTheme.shared.fontSet.font(style: .body3))
							.foregroundColor(AppTheme.shared.colorSet.offWhite)
					}.offset(x: Constants.imageOffset.vertical)
				}
				ForEach(0..<member.prefix(4).count, id: \.self) { user in
					AvatarDefault(.constant(member[user].userName), imageUrl: member[user].avatar)
						.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
						.offset(x: CGFloat(user) * Constants.imageOffset.horizontal)
				}
			})
				.frame(width: Constants.frameList.width, height: Constants.frameList.height, alignment: .trailing)
				.padding(.trailing, Constants.paddingTralling)
			HStack(alignment: .center) {
				ImageButtonCircleCall("General.Audio".localized, image: AppTheme.shared.imageSet.phoneCallIcon, action: audioAction)
				Spacer()
				ImageButtonCircleCall("General.Video".localized, image: AppTheme.shared.imageSet.videoIcon, action: videoAction)
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
	}
}

// MARK: - Private
private extension DetailContentView {
	
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
		
	}
	
	func videoAction() {
		
	}
	
}

// MARK: - Loading Content
private extension DetailContentView {
}

// MARK: - Interactor
private extension DetailContentView {
	func didSelect(_ detail: DetailType) {
		switch detail {
		case .seeMember:
			Task {
				loadable = await injected.interactors.groupDetailInteractor.getClientInGroup(by: groupData?.groupId ?? 0)
			}
		case .addMember:
			Task {
				loadable = await injected.interactors.groupDetailInteractor.searchUser(keyword: "", groupId: groupData?.groupId ?? 0)
			}
		case .removeMember:
			Task {
				loadable = await injected.interactors.groupDetailInteractor.getListMember(by: groupData?.groupId ?? 0)
			}
		case .leaveGroup:
			let result = groupData?.groupMembers.filter({ $0.id == myProfile?.id ?? "" })
			result?.forEach { member in
				Task {
					loadable = await injected.interactors.groupDetailInteractor.leaveGroup(member, groupId: groupData?.groupId ?? 0)
				}
			}
			self.presentationMode.wrappedValue.dismiss()
		}
	}
}

// MARK: - Preview
#if DEBUG
struct DetailContentView_Previews: PreviewProvider {
	static var previews: some View {
		DetailContentView(loadable: .constant(.notRequested), groupData: .constant(nil), member: .constant([]), myProfile: .constant(nil))
	}
}
#endif
