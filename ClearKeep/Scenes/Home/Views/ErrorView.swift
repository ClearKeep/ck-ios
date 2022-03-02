//
//  ErrorView.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI

struct ErrorView: View {
	let error: Error
	let retryAction: () -> Void
	var body: some View {
		VStack {
			Button(action: retryAction, label: { Text("Retry").bold() })
				.buttonStyle(PrimaryButton(mode: .dark))
			Button(action: retryAction, label: { Text("Retry").bold() })
				.buttonStyle(PrimaryButton(mode: .light))
			Button(action: retryAction, label: { Text("Retry").bold() })
				.buttonStyle(BoderButton(mode: .dark))
			Button(action: retryAction, label: { Text("Retry").bold() })
				.buttonStyle(BoderButton(mode: .light))
			Button(action: retryAction, label: { Text("Retry").bold() })
				.buttonStyle(TextButton(mode: .dark))
			Button(action: retryAction, label: { Text("Retry").bold() })
				.buttonStyle(TextButton(mode: .light))
			Button(action: retryAction, label: { Text("Retry").bold() })
				.buttonStyle(IconButton(mode: .office))
		}
	}
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
	static var previews: some View {
		ErrorView(error: NSError(domain: "", code: 0, userInfo: [
			NSLocalizedDescriptionKey: "Something went wrong"]),
				  retryAction: { })
	}
}
#endif
