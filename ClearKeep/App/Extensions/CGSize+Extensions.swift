//
//  CGSize+Extensions.swift
//  ClearKeep
//
//  Created by HOANDHTB on 19/07/2022.
//

import UIKit

extension CGSize {
	func aspectFitScale(in container: CGSize) -> CGFloat {
		if width == 0 || height == 0 {
			return 0
		}

		if height <= container.height && width > container.width {
			return container.width / width
		}
		if height > container.height && width > container.width {
			return min(container.width / width, container.height / height)
		}
		if height > container.height && width <= container.width {
			return container.height / height
		}
		if height <= container.height && width <= container.width {
			return min(container.width / width, container.height / height)
		}
		return 1.0
	}
	
	func aspectFillScale(in container: CGSize) -> CGFloat {
		if width == 0 || height == 0 {
			return 0
		}
		
		if height <= container.height && width > container.width {
			return container.height / height
		}
		if height > container.height && width > container.width {
			return max(container.width / width, container.height / height)
		}
		if height > container.height && width <= container.width {
			return container.width / width
		}
		if height <= container.height && width <= container.width {
			return max(container.width / width, container.height / height)
		}
		return 1.0
	}
}
