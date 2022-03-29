//
//  DirectMessagesView.swift
//  ClearKeep
//
//  Created by MinhDev on 29/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct DirectMessagesView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var imageUser: Image
	@State private(set) var userName: String
	@State private(set) var message: String

	// MARK: - Init
	init(imageUser: Image,
		 userName: String = "",
		 message: String = "") {
		self._imageUser = .init(initialValue: imageUser)
		self._userName = .init(initialValue: userName)
		self._message = .init(initialValue: message)
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
private extension DirectMessagesView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Private Variables
private extension DirectMessagesView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}

// MARK: - Loading Content
private extension DirectMessagesView {
	var notRequestedView: some View {
		MessageContentView(imageUser: $imageUser, userName: $userName, searchText: .constant(""), severText: .constant(""), inputStyle: .constant(.default))
	}
}

// MARK: - Interactor
private extension DirectMessagesView {
}

// MARK: - Preview
#if DEBUG
struct DirectMessagesView_Previews: PreviewProvider {
	static var previews: some View {
		DirectMessagesView(imageUser: AppTheme.shared.imageSet.faceIcon, userName: "Alex Mendes")
	}
}
#endif
