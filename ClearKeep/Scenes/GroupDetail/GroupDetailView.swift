//
//  GroupDetailView.swift
//  ClearKeep
//
//  Created by MinhDev on 28/03/2022.
//

import SwiftUI
import Common
import CommonUI

struct GroupDetailView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var imageUser: Image
	@State private(set) var userName: String
	@State private(set) var message: String
	@State private(set) var groupText: String

	// MARK: - Init
	init(imageUser: Image,
		 userName: String = "",
		 message: String = "",
		 groupText: String = "") {
		self._imageUser = .init(initialValue: imageUser)
		self._userName = .init(initialValue: userName)
		self._message = .init(initialValue: message)
		self._groupText = .init(initialValue: groupText)
	}
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			content
				.onReceive(inspection.notice) { inspection.visit(self, $0) }
				.modifier(NavigationModifier())
				.background(backgroundColorView)
				.edgesIgnoringSafeArea(.all)
		}
	}
}

// MARK: - Private
private extension GroupDetailView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Private Variables
private extension GroupDetailView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}
// MARK: - Loading Content
private extension GroupDetailView {
	var notRequestedView: some View {
		DetailContentView(imageUser: $imageUser, userName: $userName, groupText: $groupText)
	}
}

// MARK: - Interactor
private extension GroupDetailView {
}

// MARK: - Preview
#if DEBUG
struct GroupDetailView_Previews: PreviewProvider {
	static var previews: some View {
		GroupDetailView(imageUser: AppTheme.shared.imageSet.faceIcon, userName: "Alex Mendes", groupText: "CK Development")
	}
}
#endif
