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
	static let spacerTop = 50.0
	static let paddingVertical = 14.0
	static let paddingHorizontal = 24.0
}

struct CountryCode: View {
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

	@ObservedObject var datas = ReadData()
	@State private(set) var data = [CountryCodeJSON]()
	@State private(set) var search: String = ""
	@State private(set) var searchStyle: TextInputStyle = .default
	@State private(set) var isShowUserProfile: Bool = false
	@Binding var selectedNum: String
	@AppStorage("countryCode") var countryCode: String = ""

	// MARK: Body
	var body: some View {
			content
		.background(background)
		.hiddenNavigationBarStyle()
		.onAppear(perform: { self.data = self.datas.countryCodes })
	}
}

// MARK: - Private
private extension CountryCode {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension CountryCode {
	var contentView: some View {
		VStack(spacing: Constant.spacer) {
			buttonTop.padding(.top, Constant.spacerTop)
			title
			searchInput
			listCountryCode
		}
		.padding(.horizontal, Constant.paddingHorizontal)
	}

	var buttonTop: some View {
		HStack {
			Button(action: {
				presentationMode.wrappedValue.dismiss()
			}, label: {
				AppTheme.shared.imageSet.crossIcon
					.foregroundColor(foregroundCrossButton)
			})
			Spacer()
		}
		.frame(maxWidth: .infinity)
	}

	var title: some View {
		Text("Country.Code".localized)
			.frame(maxWidth: .infinity, alignment: .leading)
			.font(AppTheme.shared.fontSet.font(style: .body1))
	}

	var searchInput: some View {
		SearchTextField(searchText: $search,
						inputStyle: $searchStyle,
						inputIcon: AppTheme.shared.imageSet.searchIcon,
						placeHolder: "Country.Search".localized,
						onEditingChanged: { isEditing in
			if isEditing {
				searchStyle = .normal
			} else {
				searchStyle = .highlighted
			}
		})
			.onChange(of: self.search, perform: { text in
				self.data = datas.countryCodes.filter { $0.name.lowercased().contains(text) }
			})
	}

	var listCountryCode: some View {
		List(data) { item in
			Button {
				countryCode = "\(item.code)"
				presentationMode.wrappedValue.dismiss()
			} label: {
				HStack {
					Text("\(item.name)")
					Spacer()
					Text("\(item.code)")
				}
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.listStyle(PlainListStyle())
		.listRowBackground(AppTheme.shared.colorSet.offWhite)
	}
}

private extension CountryCode {
	var background: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.offWhite : AppTheme.shared.colorSet.black
	}

	var foregroundCrossButton: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}

	var backgroundButtonBack: [Color] {
		colorScheme == .light ? [AppTheme.shared.colorSet.offWhite, AppTheme.shared.colorSet.offWhite] : [AppTheme.shared.colorSet.black, AppTheme.shared.colorSet.black]
	}
}

struct CountryCode_Previews: PreviewProvider {
	static var previews: some View {
		CountryCode(selectedNum: .init(projectedValue: .constant("")))
	}
}
