//
//  WebView.swift
//  CommonUI
//
//  Created by Quang Pham on 27/06/2022.
//

import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {

	var url: URL
	
	public init(url: URL) {
		self.url = url
	}

	public func makeUIView(context: Context) -> WKWebView {
		return WKWebView()
	}

	public func updateUIView(_ webView: WKWebView, context: Context) {
		let request = URLRequest(url: url)
		webView.load(request)
	}
}
