//
//  BottomSheet.swift
//  CommonUI
//
//  Created by Quang Pham on 29/04/2022.
//

import SwiftUI

private enum Distances {
	static let hidden: CGFloat = 800
	static let dismiss: CGFloat = 200
}

public struct BottomSheet<Content: View>: View {
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@Binding var isPresented: Bool
	@ViewBuilder let content: Content
	
	@State private var translation = Distances.hidden
	
	let isShowHandle: Bool
	
	public var body: some View {
		ZStack {
			backgroundColor.onTapGesture {
					isPresented = false
				}
			VStack {
				Spacer()
				contentView
					.offset(y: translation)
					.animation(.interactiveSpring(), value: isPresented)
					.animation(.interactiveSpring(), value: translation)
					.gesture(
						DragGesture()
							.onChanged { value in
								guard value.translation.height > 0 else { return }
								translation = value.translation.height
							}
							.onEnded { value in
								if value.translation.height > Distances.dismiss {
									translation = Distances.hidden
									isPresented = false
								} else {
									translation = 0
								}
							}
					)
			}
			.background(
				VStack {
					Spacer()
					contentBackgroundColor
						.frame(height: translation > 200 ? 0 : 50)
				}
			)
		}
		.ignoresSafeArea()
		.onAppear {
			withAnimation {
				translation = 0
			}
		}
	}
	
	private var contentView: some View {
		ZStack(alignment: .top) {
			content
			handle
				.padding(.top, 9)
				.opacity(isShowHandle ? 1 : 0)
		}
		.background(contentBackgroundColor)
		.frame(maxWidth: .infinity)
		.cornerRadius(30)
	}
	
	private var handle: some View {
		RoundedRectangle(cornerRadius: 2.5)
			.fill(commonUIConfig.colorSet.greyLight)
			.frame(width: 47, height: 6)
	}
	
	private var backgroundColor: Color {
		colorScheme == .light ? commonUIConfig.colorSet.black.opacity(0.4) : commonUIConfig.colorSet.black.opacity(0.2)
	}
	
	var contentBackgroundColor: Color {
		colorScheme == .light ? Color.white : commonUIConfig.colorSet.darkGrey2
	}
}
