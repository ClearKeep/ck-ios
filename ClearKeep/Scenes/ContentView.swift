//
//  ContentView.swift
//  iOSBase-SwiftUI
//
//  Created by NamNH on 15/02/2022.
//

import SwiftUI
import Combine
import Common

struct ContentView: View {
	private let container: DIContainer
	private let isRunningTests: Bool
	
	init(container: DIContainer, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
		self.container = container
		self.isRunningTests = isRunningTests
	}
	
	var body: some View {
		Group {
			if isRunningTests {
				Text("Running unit tests")
			} else {
				IncomingCallView()
					.inject(container)
			}
		}
	}
}

// MARK: - Preview
#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(container: .preview)
	}
}
#endif
