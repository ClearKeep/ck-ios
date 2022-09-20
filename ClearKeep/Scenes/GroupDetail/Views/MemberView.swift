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
	static let sizeImage = CGSize(width: 60.0, height: 60.0)
	static let statusOffset = UIOffset(horizontal: 20.0, vertical: 20.0)
	static let sizeCircle = 12.0
}

struct MemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var loadable: Loadable<IGroupDetailViewModels>
	@Binding var member: [GroupDetailProfileViewModel]
	@State private(set) var groupId: Int64 = 0
	// MARK: - Init

	// MARK: - Body
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .leading, spacing: Constants.spacing) {
				ForEach(member) { client in
					Button(action: {
						action()
					}, label: {
						HStack {
							ZStack {
								AvatarDefault(.constant(client.displayName), imageUrl: client.avatar)
									.frame(width: Constants.sizeImage.width, height: Constants.sizeImage.height)
								Circle()
									.frame(width: Constants.sizeCircle, height: Constants.sizeCircle)
									.foregroundColor(client.status.color)
									.offset(x: Constants.statusOffset.vertical, y: Constants.statusOffset.horizontal)
							}
							Text(client.displayName)
								.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
								.font(AppTheme.shared.fontSet.font(style: .body2))
								.foregroundColor(foregroundColorUserName)
								.lineLimit(1)
						}
					})
				}
			}
			.padding(.leading, Constants.padding)
		}
		.applyNavigationBarPlainStyle(title: "GroupDetail.SeeMembers".localized,
									  titleColor: titleColor,
									  backgroundColors: backgroundButtonBack,
									  leftBarItems: {
			BackButtonStandard(customBack)
		},
									  rightBarItems: {
			Spacer()
		})
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
		.hiddenNavigationBarStyle()
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
		self.presentationMode.wrappedValue.dismiss()
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
		MemberView(loadable: .constant(.notRequested), member: .constant([]))
	}
}
#endif
