//
//  ServerModels.swift
//  ClearKeep
//
//  Created by MinhDev on 26/04/2022.
//

import Foundation
import UIKit
import SwiftUI

protocol IServerModels {
	var id: Int { get }
	var url: String { get }
	var title: String { get }
	var status: Bool { get }
}

struct ServerModels {
	var id: Int
	var url: String
	var title: String
	var status: Bool
}

extension ServerModels: IServerModels {
}
