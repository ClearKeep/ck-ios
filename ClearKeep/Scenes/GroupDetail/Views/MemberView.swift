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
	static let sizeImage = 64.0
	static let paddingTop = 50.0
}

struct MemberView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Binding var imageUser: Image
	@Binding var userName: String

	// MARK: - Init
	init(imageUser: Binding<Image>,
		 userName: Binding<String>) {
		self._imageUser = imageUser
		self._userName = userName
	}

	// MARK: - Body
	var body: some View {
		content
			.padding(.leading, Constants.padding)
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.background(backgroundColorView)
			.edgesIgnoringSafeArea(.all)
	}
}

// MARK: - Private
private extension MemberView {
	var content: AnyView {
		AnyView(contentView)
	}

	var buttonBack: AnyView {
		AnyView(buttonBackView)
	}

	var groupDetail: AnyView {
		AnyView(groupDetailView)
	}
}

// MARK: - Private Variables
private extension MemberView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
	
	var foregroundColorUserName: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey2 : AppTheme.shared.colorSet.greyLight
	}

	var foregroundBackButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight2
	}
}

// MARK: - Private func
private extension MemberView {
	func customBack() {
		self.presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Loading Content
private extension MemberView {
	var contentView: some View {
		VStack {
			buttonBack
				.padding(.top, Constants.paddingTop)
				.frame(maxWidth: .infinity, alignment: .leading)
			groupDetail
			Spacer()
		}
	}

	var groupDetailView: some View {
		VStack(alignment: .leading, spacing: Constants.spacing) {
			HStack {
				imageUser
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: Constants.sizeImage, height: Constants.sizeImage)
					.clipShape(Circle())
				Text(userName)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(foregroundColorUserName)
				Spacer()
			}
		}
	}

	var buttonBackView: some View {
		Button(action: customBack) {
			HStack(spacing: Constants.spacing) {
				AppTheme.shared.imageSet.chevleftIcon
					.aspectRatio(contentMode: .fit)
					.foregroundColor(foregroundBackButton)
				Text("GroupDetail.SeeMembers".localized)
					.padding(.all)
					.font(AppTheme.shared.fontSet.font(style: .body2))
			}
			.foregroundColor(foregroundBackButton)
		}
	}
}

// MARK: - Interactor
private extension MemberView {
}

// MARK: - Preview
#if DEBUG
struct MemberView_Previews: PreviewProvider {
	static var previews: some View {
		MemberView(imageUser: .constant(Image("")), userName: .constant(""))
	}
}
#endif
