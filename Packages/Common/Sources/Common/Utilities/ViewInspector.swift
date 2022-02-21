//
//  ViewInspector.swift
//  Common
//
//  Created by NamNH on 15/02/2022.
//

import Combine

// MARK: - View Inspection helper
public final class ViewInspector<V> {
	public let notice = PassthroughSubject<UInt, Never>()
	var callbacks = [UInt: (V) -> Void]()
	
	public init() {}
	
	public func visit(_ view: V, _ line: UInt) {
		if let callback = callbacks.removeValue(forKey: line) {
			callback(view)
		}
	}
}
