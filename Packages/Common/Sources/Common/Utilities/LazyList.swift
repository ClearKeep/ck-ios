//
//  LazyList.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 18.04.2020.
//  Copyright © 2020 Alexey Naumov. All rights reserved.
//

import Foundation

public struct LazyList<T> {
	public typealias Access = (Int) throws -> T?
	private let access: Access
	private let useCache: Bool
	private var cache = Cache()
	
	public let count: Int
	
	init(count: Int, useCache: Bool, _ access: @escaping Access) {
		self.count = count
		self.useCache = useCache
		self.access = access
	}
	
	func element(at index: Int) throws -> T {
		guard useCache else {
			return try get(at: index)
		}
		return try cache.sync { elements in
			if let element = elements[index] {
				return element
			}
			let element = try get(at: index)
			elements[index] = element
			return element
		}
	}
	
	private func get(at index: Int) throws -> T {
		guard let element = try access(index) else {
			throw Error.elementIsNil(index: index)
		}
		return element
	}
	
	static var empty: Self {
		return .init(count: 0, useCache: false) { index in
			throw Error.elementIsNil(index: index)
		}
	}
}

private extension LazyList {
	class Cache {
		
		private var elements = [Int: T]()
		
		func sync(_ access: (inout [Int: T]) throws -> T) throws -> T {
			guard Thread.isMainThread else {
				var result: T!
				try DispatchQueue.main.sync {
					result = try access(&elements)
				}
				return result
			}
			return try access(&elements)
		}
	}
}

extension LazyList: Sequence {
	enum Error: LocalizedError {
		case elementIsNil(index: Int)
		
		var localizedDescription: String {
			switch self {
			case let .elementIsNil(index):
				return "Element at index \(index) is nil"
			}
		}
	}
	
	public struct Iterator: IteratorProtocol {
		private var index = -1
		private var list: LazyList<T>
		
		init(list: LazyList<T>) {
			self.list = list
		}
		
		public mutating func next() -> T? {
			index += 1
			guard index < list.count else {
				return nil
			}
			do {
				return try list.element(at: index)
			} catch _ {
				return nil
			}
		}
	}
	
	public func makeIterator() -> Iterator {
		.init(list: self)
	}
	
	public var underestimatedCount: Int { count }
}

extension LazyList: RandomAccessCollection {
	public typealias Index = Int
	public var startIndex: Index { 0 }
	public var endIndex: Index { count }
	
	public subscript(index: Index) -> Iterator.Element {
		do {
			return try element(at: index)
		} catch let error {
			fatalError("\(error)")
		}
	}
	
	public func index(after index: Index) -> Index {
		return index + 1
	}
	
	public func index(before index: Index) -> Index {
		return index - 1
	}
}

extension LazyList: Equatable where T: Equatable {
	public static func == (lhs: LazyList<T>, rhs: LazyList<T>) -> Bool {
		guard lhs.count == rhs.count else { return false }
		return zip(lhs, rhs).first(where: { $0 != $1 }) == nil
	}
}

extension LazyList: CustomStringConvertible {
	public var description: String {
		let elements = self.reduce("", { str, element in
			if str.count == 0 {
				return "\(element)"
			}
			return str + ", \(element)"
		})
		return "LazyList<[\(elements)]>"
	}
}

extension RandomAccessCollection {
	public var lazyList: LazyList<Element> {
		return .init(count: self.count, useCache: false) {
			guard $0 < self.count else { return nil }
			let index = self.index(self.startIndex, offsetBy: $0)
			return self[index]
		}
	}
}
