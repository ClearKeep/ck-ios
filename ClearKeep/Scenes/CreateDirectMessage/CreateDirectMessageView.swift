//
//  CreateDirectMessageView.swift
//  ClearKeep
//
//  Created by MinhDev on 01/04/2022.
//

import SwiftUI
import Common
import CommonUI

struct CreateDirectMessageView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var imageUser: Image
	@State private(set) var userName: String

	// MARK: - Init
	init(imageUser: Image,
		 userName: String = "") {
		self._imageUser = .init(initialValue: imageUser)
		self._userName = .init(initialValue: userName)
	}

	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.edgesIgnoringSafeArea(.all)
			.background(backgroundColorView)
	}
}

// MARK: - Private
private extension CreateDirectMessageView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Private Variables
private extension CreateDirectMessageView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}

// MARK: - Loading Content
private extension CreateDirectMessageView {
	var notRequestedView: some View {
		DirectMessageContentView(imageUser: $imageUser, userName: $userName, searchText: .constant(""), severText: .constant(""), inputStyle: .constant(.default))
	}
}

// MARK: - Interactor
private extension CreateDirectMessageView {
}

// MARK: - Preview
#if DEBUG
struct CreateDirectMessageView_Previews: PreviewProvider {
	static var previews: some View {
		CreateDirectMessageView(imageUser: AppTheme.shared.imageSet.faceIcon, userName: "Alex Mendes")
	}
}
#endif
