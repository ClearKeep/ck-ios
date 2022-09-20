//
//  GalleryView.swift
//  CommonUI
//
//  Created by Quang Pham on 28/06/2022.
//

import SwiftUI

public struct GalleryView: View {
	
	let imageURLs: [String]
	let fromClientName: String
	@Binding var isShown: Bool
	
	@State private var selected: Int
	@State private var loadedImages = [Int: Image]()
	@State private var showingSaveOption = false
	
	public init(imageURLs: [String], fromClientName: String, isShown: Binding<Bool>) {
		self.imageURLs = imageURLs
		self.fromClientName = fromClientName
		self._isShown = isShown
		_selected = State(initialValue: 0)
	}
	
	public var body: some View {
		GeometryReader { reader in
			VStack(alignment: .leading) {
				ZStack {
					HStack {
						Button {
							isShown = false
						} label: {
							commonUIConfig.imageSet.crossIcon
								.resizable()
								.frame(width: 25, height: 25)
								.foregroundColor(Color.white)
						}
						Spacer()
					}
					
					Text(fromClientName)
						.font(commonUIConfig.fontSet.font(style: .input1))
						.foregroundColor(commonUIConfig.colorSet.offWhite)
				}.padding(24.0)
				
				TabView(selection: $selected) {
					ForEach(0..<imageURLs.count, id: \.self) { index in
						ZoomableScrollView {
							VStack {
								Spacer()
								if let loadedImage = loadedImages[index] {
									loadedImage
										.resizable()
										.scaledToFill()
										.aspectRatio(contentMode: .fit)
										.frame(width: reader.size.width)
										.clipped()
								} else {
									EmptyView()
										.frame(width: reader.size.width)
								}
								Spacer()
							}
						}.tag(index)
					}
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
				
				Button {
					showingSaveOption = true
				} label: {
					Image(systemName: "square.and.arrow.up")
						.foregroundColor(Color.white)
					
				}.padding(.horizontal, 24.0)
					.confirmationDialog("", isPresented: $showingSaveOption, titleVisibility: .hidden) {
						Button("Chat.Save".localized) {
							if let image = loadedImages[selected] {
								UIImageWriteToSavedPhotosAlbum(image.snapshot(), nil, nil, nil)
							}
						}
						Button("Chat.Cancel".localized, role: .cancel) {
						}
					}
				
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						ForEach(0..<imageURLs.count, id: \.self) { index in
							CachedAsyncImage(url: URL(string: imageURLs[index])) { phase in
								switch phase {
								case .empty:
									ProgressView()
										.frame(width: 65, height: 65)
								case .success(let image):
									image
										.resizable()
										.scaledToFill()
										.aspectRatio(contentMode: .fit)
										.frame(width: 65, height: 65)
										.scaleEffect(1.0001)
										.clipped()
										.onAppear {
											loadedImages[index] = image
										}
								case .failure(let error):
									EmptyView()
										.frame(width: 65, height: 65)
								}
							}.border(.white, width: imageURLs[selected] == imageURLs[index] ? 2 : 0)
							.onTapGesture {
								selected = index
							}
						}
					}
				}.padding()
				
			}.background(Color.black)
		}
	}
		
}
