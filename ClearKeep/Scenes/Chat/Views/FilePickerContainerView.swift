//
//  FilePickerContainerView.swift
//  ClearKeep
//
//  Created by Quang Pham on 23/06/2022.
//

import SwiftUI
import Common
import CommonUI

private enum Constants {
	static let spacing = 17.0
	static let padding = 15.0
	static let sizeImage = 64.0
	static let paddingHorizontal = 50.0
	static let buttonBorder = 2.0
	static let searchViewHeight = 52.0
	static let searchViewRadius = 16.0
}

struct FilePickerContainerView: View {
	// MARK: - Constants
	@Environment(\.colorScheme) var colorScheme
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	@State var filePickerShown: Bool = false
	@State var selectedFileURLs: [URL] = []
	@State var fileURLs: [URL] = []
	
	var onFinishedSelectFile: ([URL]) -> Void
	
	private let inspection = ViewInspector<Self>()

	// MARK: - Body
	var body: some View {
		content
			.edgesIgnoringSafeArea(.all)
			.sheet(isPresented: $filePickerShown) {
				FilePickerView { urls in
					fileURLs.append(contentsOf: urls)
					selectedFileURLs.append(contentsOf: urls)
				}
			}
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension FilePickerContainerView {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Private variable
private extension FilePickerContainerView {
	
	var buttonTextColor: Color {
		colorScheme == .light ? Color.white : AppTheme.shared.colorSet.greyLight2
	}
	
	var textColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}

	var buttonColor: AnyView {
		colorScheme == .light ? AnyView(foregroundButtonLight) : AnyView(foregroundButtonDark)
	}

	var foregroundButtonDark: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .topLeading, endPoint: .bottomTrailing)
	}

	var foregroundButtonLight: Color {
		AppTheme.shared.colorSet.black.opacity(0.5)
	}
}

// MARK: - Loading Content
private extension FilePickerContainerView {
	// swiftlint:disable multiple_closures_with_trailing_closure
	var contentView: some View {
		VStack {
			HStack {
				Text("Chat.YourFile".localized)
					.font(AppTheme.shared.fontSet.font(style: .input1))
					.foregroundColor(textColor)
				Spacer()
				Button(action: {
					filePickerShown = true
				}) {
					HStack {
						AppTheme.shared.imageSet.plusIcon
							.resizable()
							.frame(width: 25, height: 25)
							.foregroundColor(textColor)
						Text("Chat.AddFile".localized)
							.font(AppTheme.shared.fontSet.font(style: .input1))
							.foregroundColor(textColor)
					}
				}
			}.padding(.top, 46)
			.padding(.bottom, 34)
			
			fileListView.padding(.bottom, 19)
			
			Button(action: {
				onFinishedSelectFile(selectedFileURLs)
				BottomSheet.dismiss()
			}) {
				Text("Chat.NextButton".localized)
					.padding(.horizontal, 82)
					.frame(height: 44)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(buttonTextColor)
			}
			.background(buttonColor)
			.cornerRadius(26)
			.padding(.bottom, 41)
		}.padding(.horizontal, 16)
	}
	
	private var fileListView: some View {
		ScrollView(showsIndicators: false) {
			ForEach(fileURLs, id: \.self) { file in
				VStack(spacing: 18) {
					HStack(spacing: 14) {
						AppTheme.shared.imageSet.fileDocIcon
						Text(file.lastPathComponent)
							.font(AppTheme.shared.fontSet.font(style: .input1))
							.foregroundColor(textColor)
						Spacer()
						Button(action: {
							if selectedFileURLs.contains(file) {
								if let index = selectedFileURLs.firstIndex(of: file) {
									selectedFileURLs.remove(at: index)
								}
							} else {
								selectedFileURLs.append(file)
							}
						}) {
							Group {
								if selectedFileURLs.contains(file) {
									AppTheme.shared.imageSet.checkedIcon
										.resizable()
								} else {
									AppTheme.shared.imageSet.unCheckIcon
										.resizable()
								}
							}.frame(width: 32, height: 32)
						}.padding(.trailing, 10)
					}.padding(.top, 14)
					Divider().foregroundColor(AppTheme.shared.colorSet.seperatorDefault)
				}
			}
		}
	}
}

struct FilePickerContainerView_Previews: PreviewProvider {
	static var previews: some View {
		FilePickerContainerView { _ in
			
		}
	}
}
