//
//  TwoFactorInteractor.swift
//  ClearKeep
//
//  Created by đông on 04/04/2022.
//

import Common
import ChatSecure

protocol ITwoFactorInteractor {
	var worker: ITwoFactorWorker { get }
	func signIn(passcode: String) async
}

struct TwoFactorInteractor {
	let appState: Store<AppState>
	let channelStorage: IChannelStorage
	let socialAuthenticationService: ISocialAuthenticationService
	let authenticationService: IAuthenticationService
}

extension TwoFactorInteractor: ITwoFactorInteractor {
	var worker: ITwoFactorWorker {
		let remoteStore = TwoFactorRemoteStore()
		let inMemoryStore = TwoFactorInMemoryStore()
		return TwoFactorWorker(remoteStore: remoteStore, inMemoryStore: inMemoryStore)
	}

	func signIn(passcode: String) async {
		
	}
}
