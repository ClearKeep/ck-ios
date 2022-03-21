//
//  ArrayExtension.swift
//  ChatSecure
//
//  Created by NamNH on 20/03/2022.
//

import Foundation

extension Array {
	func devided() -> ([Element], [Element]) {
		let half = count / 2 + count % 2
		let head = self[0..<half]
		let tail = self[half..<count]

		return (Array(head), Array(tail))
	}
}
