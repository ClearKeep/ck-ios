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

struct CountryCode: View {
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[IProfileModel]>
	@State private(set) var search: String
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var isExpand = false
	@State private(set) var selectedNum = 1

	init(samples: Loadable<[IProfileModel]> = .notRequested,
		 search: String = "",
		 inputStyle: TextInputStyle = .default) {
		self._samples = .init(initialValue: samples)
		self._search = .init(initialValue: search)
		self._searchStyle = .init(initialValue: inputStyle)
	}
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
		VStack {
			title
			profileSettings
				.padding(.top, 20)
			textInput
				.padding(.top, 20)
			twoFactor
				.padding(.top, 20)
			Spacer()
		}
		.padding(.horizontal, 20)
	}

	var title: some View {
		Text("Country.code".localized)
		.frame(maxWidth: .infinity)
	}

	var searchInput: some View {
		SearchTextField(searchText: $search,
						inputStyle: $searchStyle,
						placeHolder: "Country.search".localized,
						onEditingChanged: { isEditing in
			if isEditing {
				searchStyle = .normal
			} else {
				searchStyle = .highlighted
			}
		})
	}
}

struct CountryCode_Previews: PreviewProvider {
    static var previews: some View {
        CountryCode()
    }
}
