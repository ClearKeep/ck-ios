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
	@State private(set) var searchText: String
	@State private(set) var inputStyle: TextInputStyle = .default
	@State private(set) var imageUser: Image
	@State private(set) var userName: String
	@State private(set) var message: String
	@State private(set) var groupText: String
	@State private(set) var dateMessage: String
	@Binding var isSearchAction: Bool

	// MARK: - Init
	init(searchText: String = "",
		 inputStyle: TextInputStyle = .default,
		 imageUser: Image,
		 userName: String = "",
		 message: String = "",
		 groupText: String = "",
		 dateMessage: String = "",
		 isSearchAction: Binding<Bool>) {
		self._searchText = .init(initialValue: searchText)
		self._inputStyle = .init(initialValue: inputStyle)
		self._imageUser = .init(initialValue: imageUser)
		self._userName = .init(initialValue: userName)
		self._message = .init(initialValue: message)
		self._groupText = .init(initialValue: groupText)
		self._dateMessage = .init(initialValue: dateMessage)
		self._isSearchAction = isSearchAction
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
private extension SearchView {
	var content: AnyView {
		AnyView(contentView)
	}
	
	var backgroundColorView: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.background : AppTheme.shared.colorSet.black
	}
}

// MARK: - Loading Content
private extension SearchView {
	var contentView: some View {
		VStack {
			SearchContentView(imageUser: $imageUser, userName: $userName, message: $message, groupText: $groupText, dateMessage: $dateMessage)
			Spacer()
		}
	}
}

// MARK: - Interactor
private extension SearchView {
}

// MARK: - Preview
#if DEBUG
struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(imageUser: AppTheme.shared.imageSet.faceIcon, userName: "", message: "", groupText: "", dateMessage: "", isSearchAction: .constant(false))
	}
}
#endif
