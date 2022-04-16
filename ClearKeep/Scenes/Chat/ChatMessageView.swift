//
//  ChatMessageView.swift
//  ClearKeep
//
//  Created by MinhDev on 30/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct ChatMessageView: View {
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
private extension ChatMessageView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension ChatMessageView {
	var notRequestedView: some View {
		ChatUserView(imageUser: .constant(Image("")), userName: .constant(""), searchText: .constant(""), groupText: .constant(""), severText: .constant(""), inputStyle: .constant(.default))
	}
}

// MARK: - Private Variables
private extension ChatMessageView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}

// MARK: - Interactor
private extension ChatMessageView {
}
	
// MARK: - Preview
#if DEBUG
struct ChatMessageView_Previews: PreviewProvider {
	static var previews: some View {
		ChatMessageView(imageUser: AppTheme.shared.imageSet.faceIcon)
	}
}
#endif
