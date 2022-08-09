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
	
	enum AlertCall {
		case changeTypeCall
		case endCall
		case error(error: LoginViewError)
		
		var title: String {
			if case .error(let err) = self {
				return err.title
			}
			
			return "Call.Warning".localized
		}
		
		var description: String {
			switch self {
			case .changeTypeCall:
				return "Call.SwitchCall".localized
			case .endCall:
				return"Call.EndQuestion".localized
			case .error(let err):
				return err.message
			}
		}
		
		var primaryButtonTitle: String {
			switch self {
			case .changeTypeCall:
				return "Call.OK".localized
			case .endCall:
				return "Call.Leave".localized
			case .error(let error):
				return error.primaryButtonTitle
			}
		}
		
		var secondButtonTitle: String {
			return "Call.Cancel".localized
		}
	}
}

struct InCallView_Previews: PreviewProvider {
    static var previews: some View {
		InCallView(viewModel: .init())
    }
}
