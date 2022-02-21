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
		
		static var stub: Self {
			.init(homeInteractor: StubHomeInteractor(sampleAPIService: DependencyResolver.shared.sampleAPIService))
		}
	}
}
