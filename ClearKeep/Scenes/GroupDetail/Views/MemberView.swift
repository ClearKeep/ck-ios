//
//  MemberView.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 10.0
	static let padding = 20.0
}

struct MemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var loadable: Loadable<GroupDetailViewModels>
	@Binding var clientData: [GroupDetailClientViewModel]
	@State private(set) var groupId: Int64 = 0

	// MARK: - Init

	// MARK: - Body
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				ForEach(clientData) { client in
					UserPeerButton(.constant(client.userName), imageUrl: client.avatar, action: action)
				}
			}
		}
		.padding(.leading, Constants.padding)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.applyNavigationBarPlainStyle(title: "GroupDetail.SeeMembers".localized,
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
private extension MemberView {
}

// MARK: - Private Variables
private extension MemberView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.background, AppTheme.shared.colorSet.background] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}

	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension MemberView {
	func customBack() {
		Task {
			loadable = await injected.interactors.groupDetailInteractor.getGroup(by: groupId)
		}
	}

	func action() {
	}
}

// MARK: - Loading Content
private extension MemberView {
}

// MARK: - Interactor
private extension MemberView {
}

// MARK: - Preview
#if DEBUG
struct MemberView_Previews: PreviewProvider {
	static var previews: some View {
		MemberView(loadable: .constant(.notRequested), clientData: .constant([]))
	}
}
#endif
