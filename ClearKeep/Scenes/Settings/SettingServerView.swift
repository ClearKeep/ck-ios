//
//  SettingServerView.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import SwiftUI
import Common

struct SettingServerView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		content
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Private
private extension SettingServerView {
	var content: AnyView {
		AnyView(notRequestedView)
	}
}

// MARK: - Loading Content
private extension SettingServerView {
	var notRequestedView: some View {
		ServerSettingContentView()
	}
}

// MARK: - Interactor
private extension SettingServerView {
}
	
// MARK: - Preview
#if DEBUG
struct SettingServerView_Previews: PreviewProvider {
	static var previews: some View {
		SettingServerView()
	}
}
#endif
