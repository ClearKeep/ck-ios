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
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

	@Binding var isShowing: Bool
	@State private(set) var samples: Loadable<[IProfileModel]>
	@State private(set) var search: String
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var isExpand = false
	@State private(set) var selectedNum = 1

	init(isShowing: Binding<Bool>, samples: Loadable<[IProfileModel]> = .notRequested,
		 search: String = "",
		 inputStyle: TextInputStyle = .default) {
		self._isShowing = isShowing
		self._samples = .init(initialValue: samples)
		self._search = .init(initialValue: search)
		self._searchStyle = .init(initialValue: inputStyle)
	}
	
	var body: some View {
		VStack {
//		Button("Close") {
//			isShowing = false
//		}
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
		VStack(spacing: 25.0) {
			buttonTop
			title
			searchInput
			listCountry
//			Spacer()
		}
		.padding(.horizontal, 20)
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

	var listCountry: some View {
		List(1..<50) { row in
			Text("\(row)")
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.listStyle(PlainListStyle())
		.listRowBackground(Color.green.opacity(0.5))
	}
}

struct CountryCode_Previews: PreviewProvider {
    static var previews: some View {
		CountryCode(isShowing: .init(projectedValue: .constant(false)))
    }
}
