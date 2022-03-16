//
//  CountryCode.swift
//  ClearKeep
//
//  Created by đông on 14/03/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
}

struct CountryCode: View {
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

	@Binding var isShowing: Bool
	@State private(set) var samples: Loadable<[IProfileModel]>
	@State private(set) var search: String
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var isShowUserProfile = false
	@Binding private(set) var selectedNum: String

	init(selectedNum: Binding<String>, isShowing: Binding<Bool>, samples: Loadable<[IProfileModel]> = .notRequested,
		 search: String = "",
		 inputStyle: TextInputStyle = .default) {
		self._selectedNum = selectedNum
		self._isShowing = isShowing
		self._samples = .init(initialValue: samples)
		self._search = .init(initialValue: search)
		self._searchStyle = .init(initialValue: inputStyle)
	}

	let values = [
			"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
		]
	
	var body: some View {
		VStack {
			content
		}
		.background(Color.white)
	}
}

// MARK: - Private
private extension CountryCode {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension CountryCode {
	var notRequestedView: some View {
		VStack(spacing: Constant.spacer) {
			buttonTop
			title
			searchInput
			listCountryCode
		}
		.padding(.horizontal, Constant.paddingHorizontal)
	}

	var buttonTop: some View {
		HStack {
			Button(action: {
				isShowing = false
			}, label: {
				AppTheme.shared.imageSet.crossIcon
			})
			Spacer()
		}
		.frame(maxWidth: .infinity)
	}

	var title: some View {
		Text("Country.code".localized)
			.frame(maxWidth: .infinity, alignment: .leading)
			.font(AppTheme.shared.fontSet.font(style: .body1))
	}

	var searchInput: some View {
		SearchTextField(searchText: $search,
						inputStyle: $searchStyle,
						inputIcon: AppTheme.shared.imageSet.searchIcon,
						placeHolder: "Country.search".localized,
						onEditingChanged: { isEditing in
			if isEditing {
				searchStyle = .normal
			} else {
				searchStyle = .highlighted
			}
		})
	}

	var listCountryCode: some View {
		List(values, id: \.self) { value in
			Button {
				self.selectedNum = value
				isShowing = false
			} label: {
				Text("\(value)")
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.listStyle(PlainListStyle())
	}
}

struct CountryCode_Previews: PreviewProvider {
	static var previews: some View {
		CountryCode(selectedNum: .init(projectedValue: .constant("")), isShowing: .init(projectedValue: .constant(false)))
	}
}
