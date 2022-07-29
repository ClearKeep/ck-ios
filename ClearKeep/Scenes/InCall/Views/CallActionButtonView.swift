//
//  CallActionButtonView.swift
//  ClearKeep
//
//  Created by Luong Minh Hiep on 18/05/2021.
//

import SwiftUI

struct CallActionButtonView: View {
    var onIcon: Image
    var offIcon: Image
    var isOn: Bool
    var activeForegroundColor: Color
    var activeBackgroundColor: Color
    var inactiveForegroundColor: Color
    var inactiveBackgroundColor: Color
	var borderColor: Color
    var title: String
	var styleButton: StyleButton = .video
    var action: () -> Void
    
    var widthButton: CGFloat = 64
    var widthInsideIcon: CGFloat = 40
    
    var body: some View {
		VStack(spacing: 16) {
			Button(action: {
				action()
			}, label: {
				(isOn ? onIcon: offIcon)
					.renderingMode(.template)
					.resizable()
					.scaledToFit()
					.foregroundColor(isOn ? activeForegroundColor : inactiveForegroundColor)
					.frame(width: widthInsideIcon, height: widthInsideIcon)
					.padding(.all, widthButton / 2 - widthInsideIcon / 2)
					.background(isOn ? activeBackgroundColor : inactiveBackgroundColor)
					.cornerRadius(widthButton / 2)
					.overlay(Circle().stroke(borderColor, lineWidth: isOn ? 1 : 0))
			})
			
			if !title.isEmpty {
				Text(title)
					.font(AppTheme.shared.fontSet.font(style: .body2))
					.foregroundColor(AppTheme.shared.colorSet.offWhite)
			}
		}
    }
}

extension CallActionButtonView {
    
    enum StyleButton {
        case video
        case voice
        case endCall
    }
    
    init(onIcon: Image,
         offIcon: Image,
         isOn: Bool,
         title: String = "",
         styleButton: StyleButton = .video,
         widthButton: CGFloat = 64,
         widthInsideIcon: CGFloat = 24,
         action: @escaping () -> Void) {
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.isOn = isOn
        self.title = title
        self.widthButton = widthButton
        self.widthInsideIcon = widthInsideIcon
        self.action = action
		self.styleButton = styleButton
        switch styleButton {
        case .video:
			self.activeForegroundColor = AppTheme.shared.colorSet.offWhite
			self.activeBackgroundColor = AppTheme.shared.colorSet.primaryDefault
			self.inactiveForegroundColor = AppTheme.shared.colorSet.offWhite
            self.inactiveBackgroundColor = AppTheme.shared.colorSet.primaryDefault
			self.borderColor = AppTheme.shared.colorSet.primaryDefault
        case .voice:
			self.activeForegroundColor = AppTheme.shared.colorSet.offWhite
            self.activeBackgroundColor = Color.clear
            self.inactiveForegroundColor = AppTheme.shared.colorSet.grey1
            self.inactiveBackgroundColor = AppTheme.shared.colorSet.offWhite
			self.borderColor = AppTheme.shared.colorSet.offWhite
        case .endCall:
            self.activeForegroundColor = AppTheme.shared.colorSet.offWhite
            self.activeBackgroundColor = AppTheme.shared.colorSet.errorDefault
			self.inactiveForegroundColor = AppTheme.shared.colorSet.offWhite
            self.inactiveBackgroundColor = AppTheme.shared.colorSet.errorDefault
			self.borderColor = AppTheme.shared.colorSet.errorDefault
        }
    }
}

struct CallActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
        }
        .background(Color.green)
    }
}
