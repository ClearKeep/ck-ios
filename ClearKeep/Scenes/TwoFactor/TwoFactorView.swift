//
//  TwoFactorView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Common

struct TwoFactorView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()

	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	@State private(set) var userId: String = ""
	@State private(set) var otp: String = ""
	@State private(set) var otpHash: String = ""
	@State private(set) var hashKey: String = ""

	// MARK: - Body
	var body: some View {
			content
				.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension TwoFactorView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension TwoFactorView {
	var notRequestedView: some View {
		TwoFactorContentView()
	}
}

// MARK: - Interactor
private extension TwoFactorView {
}

// MARK: - Preview
#if DEBUG
struct TwoFactorView_Previews: PreviewProvider {
	static var previews: some View {
		TwoFactorView()
	}
}
#endif
