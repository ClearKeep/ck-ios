//
//  SearchView.swift
//  ClearKeep
//
//  Created by MinhDev on 22/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constants {
	static let paddingLeading = 100.0
	static let padding = 20.0
	static let sizeOffset = 30.0
	static let sizeIcon = 24.0
}

struct SearchView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var searchText: String = ""
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var imageUser: Image
	@State private(set) var userName: String = "Alex Mendes"
	@State private(set) var message: String = "this CLK is ready for test this CLK is ready for test this CLK is ready for test"
	@State private(set) var groupText: String = "CLK Group"
	@State private(set) var dateMessage: String = "5/5/2021"
	@Binding var isSearchAction: Bool

	// MARK: - Init
	init(inputStyle: TextInputStyle = .default,
		 imageUser: Image,
		 isSearchAction: Binding<Bool>) {
		self._inputStyle = .init(initialValue: inputStyle)
		self._imageUser = .init(initialValue: imageUser)
		self._isSearchAction = isSearchAction
	}

	// MARK: - Body
	var body: some View {
		SearchContentView(imageUser: $imageUser, userName: $userName, message: $message, groupText: $groupText, dateMessage: $dateMessage)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.modifier(NavigationModifier())
			.edgesIgnoringSafeArea(.all)
			.background(backgroundColorView)
	}
}

// MARK: - Private
private extension SearchView {
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}

// MARK: - Preview
#if DEBUG
struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(imageUser: AppTheme.shared.imageSet.faceIcon, isSearchAction: .constant(false))
	}
}
#endif
