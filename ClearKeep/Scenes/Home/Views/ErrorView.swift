//
//  ErrorView.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI

struct ErrorView: View {
	// MARK: - Variables
	let error: Error
	let retryAction: () -> Void
	// MARK: - Body
	var body: some View {
		VStack {
			Text("An Error Occured")
				.font(.title)
			Text(error.localizedDescription)
				.font(.callout)
				.multilineTextAlignment(.center)
				.padding(.bottom, 40).padding()
			Button(action: retryAction, label: { Text("Retry").bold() })
		}
	}
}
// MARK: - Preview
#if DEBUG
struct ErrorView_Previews: PreviewProvider {
	static var previews: some View {
		ErrorView(error: NSError(domain: "", code: 0, userInfo: [
			NSLocalizedDescriptionKey: "Something went wrong"]),
				  retryAction: { })
	}
}
#endif
