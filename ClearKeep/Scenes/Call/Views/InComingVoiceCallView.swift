//
//  InComingVoiceCallView.swift
//  ClearKeep
//
//  Created by đông on 03/04/2022.
//

import SwiftUI
import Combine
import Common
import CommonUI

private enum Constant {
	static let spacerTopView = 90.0
	static let spacer = 25.0
	static let paddingVertical = 14.0
	static let sizeImage = 120.0
	static let paddingButtonNext = 60.0
	static let borderLineWidth = 2.0
	static let opacity = 0.8
}

struct InComingVoiceCallView: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
	@State private(set) var samples: Loadable<[ICallModel]>
	@State private(set) var isTappedDecline: Bool = false
	@State private(set) var isTappedAnswer: Bool = false
	
	// MARK: - Init
	public init(samples: Loadable<[ICallModel]> = .notRequested) {
		self._samples = .init(initialValue: samples)
	}
	
	// MARK: - Body
	var body: some View {
		VStack(spacing: Constant.spacer) {
			Text("Call.Incomming.Voice".localized)
				.padding(.all)
				.font(AppTheme.shared.fontSet.font(style: .input2))
				.foregroundColor(AppTheme.shared.colorSet.grey5)
				.frame(maxWidth: .infinity, alignment: .center)
				.padding(.top, Constant.spacerTopView)
			
			ZStack {
				Circle()
					.fill(backgroundGradientPrimary)
					.frame(width: Constant.sizeImage, height: Constant.sizeImage)
				AppTheme.shared.imageSet.userIcon
			}
			
			Text("Alex".localized)
				.frame(maxWidth: .infinity, alignment: .center)
				.font(AppTheme.shared.fontSet.font(style: .display2))
				.foregroundColor(AppTheme.shared.colorSet.offWhite)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			
			HStack {
				VStack {
					Button {
						isTappedDecline.toggle()
					} label: {
						ZStack {
							Circle()
								.strokeBorder(backgroundDecline, lineWidth: Constant.borderLineWidth)
								.background(Circle().foregroundColor(backgroundDecline))
								.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
							AppTheme.shared.imageSet.phoneOffIcon
								.foregroundColor(AppTheme.shared.colorSet.offWhite)
						}
					}
					Text("Call.Decline".localized)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.frame(maxWidth: .infinity)
				
				VStack {
					Button {
						isTappedAnswer.toggle()
					} label: {
						ZStack {
							Circle()
								.strokeBorder(backgroundAnswer, lineWidth: Constant.borderLineWidth)
								.background(Circle().foregroundColor(backgroundAnswer))
								.frame(width: Constant.paddingButtonNext, height: Constant.paddingButtonNext)
							AppTheme.shared.imageSet.phoneCallIcon
								.foregroundColor(AppTheme.shared.colorSet.offWhite)
						}
					}
					Text("Call.Answer".localized)
						.font(AppTheme.shared.fontSet.font(style: .body2))
						.foregroundColor(AppTheme.shared.colorSet.offWhite)
				}
				.frame(maxWidth: .infinity)
			}
			.frame(maxWidth: .infinity)
			.padding(.bottom, Constant.paddingButtonNext)
			Spacer()
		}
		.padding(.horizontal, Constant.paddingVertical)
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
		.background(AppTheme.shared.colorSet.warningDefault.opacity(Constant.opacity))
		.edgesIgnoringSafeArea(.all)
		.navigationBarBackButtonHidden(true)
	}
}

// MARK: - Private
private extension InComingVoiceCallView {
}

// MARK: - Loading Content
private extension InComingVoiceCallView {
}

// MARK: - Color func
private extension InComingVoiceCallView {
	var backgroundGradientPrimary: LinearGradient {
		LinearGradient(gradient: Gradient(colors: AppTheme.shared.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
	}
	
	var backgroundDecline: Color {
		AppTheme.shared.colorSet.errorDefault
	}
	
	var backgroundAnswer: Color {
		AppTheme.shared.colorSet.successDefault
	}
}

struct InComingVoiceCallView_Previews: PreviewProvider {
	static var previews: some View {
		InComingVoiceCallView()
	}
}