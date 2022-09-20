//
//  AppLogo.swift
//  CommonUI
//
//  Created by NamNH on 09/05/2022.
//

import SwiftUI

public struct AppLogo: View {
	// MARK: - Variables
	@Environment(\.colorScheme) var colorScheme
	
	// MARK: - Init
	public init() {}
	
	// MARK: - Body
	public var body: some View {
		commonUIConfig.imageSet.logo
		 .resizable()
		 .aspectRatio(contentMode: .fit)
		 .frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
