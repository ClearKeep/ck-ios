//
//  DIContainer.Interactors.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 24.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

extension DIContainer {
	struct Interactors {
		let homeInteractor: IHomeInteractor
		let loginInteractor: ILoginInteractor
		let registerInteractor: IRegisterInteractor
		let fogotPasswordInteractor: IFogotPasswordInteractor
		let newPasswordInteractor: INewPasswordInteractor
		let changePasswordInteractor: IChangePasswordInteractor
		
		static var stub: Self {
			.init(homeInteractor: StubHomeInteractor(channelStorage: DependencyResolver.shared.channelStorage),
				  loginInteractor: StubLoginInteractor(channelStorage: DependencyResolver.shared.channelStorage, socialAuthenticationService: DependencyResolver.shared.socialAuthenticationService, authenticationService: DependencyResolver.shared.authenticationService),
				  registerInteractor: StubRegisterInteractor(channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService),
				  fogotPasswordInteractor: StubFogotPasswordInteractor(channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService),
				  newPasswordInteractor: StubNewPasswordInteractor(channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService),
				  changePasswordInteractor: StubChangePasswordInteractor(channelStorage: DependencyResolver.shared.channelStorage, authenticationService: DependencyResolver.shared.authenticationService))
		}
	}
}
