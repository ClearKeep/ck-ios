//
//  MultipleImagePicker.swift
//  CommonUI
//
//  Created by Quang Pham on 17/06/2022.
//

import SwiftUI
import Photos

private enum Constants {
	static let padding = 15.0
	static let sizeIcon = 30.0
	static let paddingTop = 50.0
	static let paddingHorizontal = 17.0
}

public struct MultipleImagePicker: View {
	
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.colorScheme) var colorScheme
	
	var doneAction: ([SelectedImageModel]) -> Void
		
	@StateObject private var viewModel = ImagePickerViewModel()
		
	private var columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
	// MARK: - Init
	public init(doneAction: @escaping ([SelectedImageModel]) -> Void) {
		self.doneAction = doneAction
	}
	
	public var body: some View {
		VStack {
			headerView
			GeometryReader { geometryReader in
				ScrollView(.vertical, showsIndicators: false) {
					LazyVGrid(columns: columns, spacing: 0) {
						ForEach($viewModel.fetchedImages) { $photo in
							AssetImageSelectableView(
								asset: photo,
								size: getImageSize(width: geometryReader.size.width),
								selected: $viewModel.selectedImages
							).onAppear {
								viewModel.asyncThumbnail(asset: photo.asset, size: getImageSize(width: geometryReader.size.width)) { image in
									photo.thumbnail = image
								}
								viewModel.getAssetURL(asset: photo.asset) { url in
									photo.url = url
								}
							}
						}
					}
				}.introspectScrollView { scrollView in
					scrollView.alwaysBounceVertical = false
				}
			}
			.padding(.horizontal, Constants.paddingHorizontal)
			.onAppear(perform: {
				viewModel.requestAuthorization()
			})
		}
		.background(backgroundColorView)
		.edgesIgnoringSafeArea(.all)
	}
	
	private var headerView: some View {
		return HStack {
			Button(action: {
				presentationMode.wrappedValue.dismiss()
			}, label: {
				commonUIConfig.imageSet.crossIcon
					.resizable()
					.foregroundColor(foregroundButton)
					.frame(width: Constants.sizeIcon, height: Constants.sizeIcon)
			})
			Spacer()
			Button(action: {
				self.doneAction(viewModel.selectedImages.map { $0.toSelectedImageModel() })
				presentationMode.wrappedValue.dismiss()
			}, label: {
				Text("Chat.UploadButton".localized + " (\(viewModel.selectedImages.count))")
					.font(commonUIConfig.fontSet.font(style: .body3))
					.foregroundColor(foregroundButton)
			}).disabled(viewModel.selectedImages.count == 0)
		}
		.padding(.top, Constants.paddingTop)
		.padding([.leading, .trailing, .bottom], Constants.padding)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(backgroundGradientPrimary)
	}
	
	private func getImageSize(width: CGFloat) -> CGSize {
		let size = width / CGFloat(2)
		return CGSize(width: size, height: size)
	}
	
	var backgroundGradientPrimary: AnyView {
		colorScheme == .light
		? AnyView(LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing))
		: AnyView(commonUIConfig.colorSet.darkGrey2)
	}
	
	var backgroundColorView: Color {
		colorScheme == .light ? commonUIConfig.colorSet.background : commonUIConfig.colorSet.black
	}
	
	var foregroundButton: Color {
		colorScheme == .light ? commonUIConfig.colorSet.offWhite : commonUIConfig.colorSet.greyLight
	}
}
