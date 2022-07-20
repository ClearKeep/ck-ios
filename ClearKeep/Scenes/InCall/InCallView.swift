//
//  InCallView.swift
//  ClearKeep
//
//  Created by HOANDHTB on 20/07/2022.
//

import SwiftUI
import ChatSecure
import CommonUI

struct InCallView: View {
	@ObservedObject var viewModel: CallViewModel
	
	var body: some View {
		Group {
			if viewModel.callGroup {
				GroupIncallView(viewModel: viewModel)
			} else {
				PeerCallView(viewModel: viewModel)
			}
		}
		.grandientBackground()
		.edgesIgnoringSafeArea(.all)
		.onAppear(perform: {
			if let callBox = CallManager.shared.calls.first {
				viewModel.updateCallBox(callBox: callBox)
			}
		})
	}
}

struct InCallView_Previews: PreviewProvider {
    static var previews: some View {
		InCallView(viewModel: .init())
    }
}
