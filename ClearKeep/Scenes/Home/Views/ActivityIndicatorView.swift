//
//  ActivityIndicatorView.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {

	func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
		return UIActivityIndicatorView(style: .large)
	}

	func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
		uiView.startAnimating()
	}
}
