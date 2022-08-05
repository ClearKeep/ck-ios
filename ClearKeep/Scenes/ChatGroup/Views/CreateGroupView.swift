//
//  SwiftUIView.swift
//  ClearKeep
//
//  Created by đông on 09/05/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let heightButton = 40.0
	static let cornerRadiusButtonNext = 40.0
	static let paddingButtonNext = 60.0
	static let sizeImage = 64.0
	static let buttonSize = CGSize(width: 196.0, height: 40.0)
}

struct CreateGroupView: View {
	// MARK: - Variables
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.injected) private var injected: DIContainer
	let inspection = ViewInspector<Self>()
	@Environment(\.colorScheme) var colorScheme
	
	@State private var nameGroup: String = ""
	@State private var idClient: String = ""
	@State private(set) var nameGroupStyle: TextInputStyle = .default
	@Binding var loadable: Loadable<ICreatGroupViewModels>
	@Binding var getProfile: CreatGroupProfieViewModel?
	@Binding var clientInGroup: [CreatGroupGetUsersViewModel]
	@State private var messageAlert: String = ""
	@State private var showAlertPopup: Bool = false
	@State private var showingAlert = false
	
	// MARK: - Body
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				Text("GroupChat.Group.Name".localized)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundButtonBack)
				
				CommonTextField(text: $nameGroup,
								inputStyle: $nameGroupStyle,
								inputIcon: Image(""),
								placeHolder: "GroupChat.Named".localized,
								keyboardType: .default,
								onEditingChanged: { isEditing in
					nameGroupStyle = isEditing ? .normal : .highlighted
				})
				Text("GroupChat.User.Inside".localized)
					.foregroundColor(foregroundText)
					.font(AppTheme.shared.fontSet.font(style: .input2))
			}
			ScrollView {
				ForEach(clientInGroup) { item in
					ListUser(imageUrl: .constant(""), name: .constant(item.displayName))
				}
			}
			RoundedGradientButton("GroupChat.Create".localized,
								  disabled: .constant(nameGroup.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty),
								  action: creatGroup)
				.frame(width: Constants.buttonSize.width)
				.padding(.bottom, Constants.paddingButtonNext)
		}
		.padding(.horizontal, Constants.paddingVertical)
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
		.applyNavigationBarPlainStyle(title: "GroupChat.Back.Button".localized,
									  titleColor: titleColor,
									  backgroundColors: backgroundButtonBack,
									  leftBarItems: {
			BackButtonStandard(customBack)
		},
									  rightBarItems: {
			Spacer()
		})
        .alert("GroupChat.Warning".localized, isPresented: $showAlertPopup) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(self.messageAlert)
        }
	}
}

// MARK: - Color func
private extension CreateGroupView {
	var foregroundButtonBack: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.offWhite
	}
	
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
	
	var foregroundText: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight
	}
	
	var titleColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private Func
private extension CreateGroupView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
	
	func creatGroup() {
		if self.nameGroup.trimmingCharacters(in: .whitespacesAndNewlines).count > 100 {
			self.messageAlert = "Group name must not be longer than 100 characters"
			self.showAlertPopup = true
			return
		}
		
		self.presentationMode.wrappedValue.dismiss()
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			var clientGroup = clientInGroup
			let domain = DependencyResolver.shared.channelStorage.currentDomain
			let profile = DependencyResolver.shared.channelStorage.currentServer?.profile
			let client = CreatGroupGetUsersViewModel(id: profile?.userId ?? "", displayName: profile?.userName ?? "", workspaceDomain: domain)
			clientGroup.append(client)
			loadable = await injected.interactors.chatGroupInteractor.createGroup(by: profile?.userId ?? "fail", groupName: nameGroup.trimmingCharacters(in: .whitespacesAndNewlines), groupType: "group", lstClient: clientGroup)

		}
	}
}

// MARK: - Preview
#if DEBUG
struct CreateGroupView_Previews: PreviewProvider {
	static var previews: some View {
		CreateGroupView(loadable: .constant(.notRequested), getProfile: .constant(nil), clientInGroup: .constant([]))
	}
}
#endif
