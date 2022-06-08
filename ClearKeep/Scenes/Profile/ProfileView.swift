//
//  ProfileView.swift
//  ClearKeep
//
//  Created by đông on 27/04/2022.
//

import SwiftUI
import Common
import CommonUI

struct ProfileView: View {
	// MARK: - Constants
	private let inspection = ViewInspector<Self>()
	
	// MARK: - Variables
	@Environment(\.injected) private var injected: DIContainer
	
	// MARK: - Body
	var body: some View {
		content
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.hiddenNavigationBarStyle()
	}
}

// MARK: - Private
private extension ProfileView {
	var content: AnyView {
		AnyView(contentView)
	}
}

// MARK: - Loading Content
private extension ProfileView {
	var contentView: some View {
		UserProfileContentView()
	}
}

// MARK: - Interactor
private extension ProfileView {
}

// MARK: - Preview
#if DEBUG
struct ProfileView_Previews: PreviewProvider {
	static var previews: some View {
		ProfileView()
	}
}
#endif
