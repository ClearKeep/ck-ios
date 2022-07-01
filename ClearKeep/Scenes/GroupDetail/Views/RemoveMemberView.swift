//
//  RemoveMember.swift
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
	static let sizeImage = 64.0
	static let paddingTop = 50.0
	static let sizeIcon = 18.0
}

struct RemoveMemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var loadable: Loadable<IGroupDetailViewModels>
	@Binding var clientData: [GroupDetailClientViewModel]
	@State private(set) var groupId: Int64 = 0
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var searchText: String = ""
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				SearchTextField(searchText: $searchText,
								inputStyle: $searchStyle,
								inputIcon: AppTheme.shared.imageSet.searchIcon,
								placeHolder: "GroupDetail.Search".localized,
								onEditingChanged: { isEditing in
					searchStyle = isEditing ? .highlighted : .normal })
					.onChange(of: searchText) { text in
						search(text: text)
					}
				ForEach(clientData) { client in
					RemoveButtonView(.constant(client.userName), imageUrl: client.avatar, action: { deleteUser(client) })
				}
			}
		}
		.padding(.horizontal, Constants.padding)
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.applyNavigationBarPlainStyle(title: "GroupDetail.RemoveMember".localized,
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
private extension RemoveMemberView {
}

// MARK: - Private Variables
private extension RemoveMemberView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.background, AppTheme.shared.colorSet.background] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
	
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension RemoveMemberView {
	func customBack() {
		Task {
			loadable = await injected.interactors.groupDetailInteractor.getGroup(by: groupId)
		}
	}
	
	func deleteUser(_ data: GroupDetailClientViewModel) {
		Task {
			loadable = await injected.interactors.groupDetailInteractor.leaveGroup(data, groupId: groupId)
		}
	}
	
	func search(text: String) {
		self.clientData = clientData.filter { $0.userName.lowercased().prefix(1) == text.lowercased().prefix(1) }
	}
}

// MARK: - Loading Content
private extension RemoveMemberView {
	
}

// MARK: - Interactor
private extension RemoveMemberView {
}

// MARK: - Preview
#if DEBUG
struct RemoveMemberView_Previews: PreviewProvider {
	static var previews: some View {
		RemoveMemberView(loadable: .constant(.notRequested), clientData: .constant([]))
	}
}
#endif
