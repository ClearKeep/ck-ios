//
//  GridView.swift
//  ClearKeep
//
//  Created by VietAnh on 1/4/21.
//

import Foundation
import SwiftUI

public struct GridView<Content: View, T: Hashable>: View {
	
	private let columns: Int
	private let hasBigItem: Bool
	
	// Multi-dimensional array of your list. Modified as per rendering needs.
	private var list: [[T]] = []
	
	// This block you specify in 'UIGrid' is stored here
	private let content: (T) -> Content
	
	public init(columns: Int, list: [T], @ViewBuilder content:@escaping (T) -> Content) {
		self.columns = columns
		self.content = content
		self.hasBigItem = list.count % 2 == 1
		self.setupList(list)
	}
	
	// setupList(_:) Converts your array into multi-dimensional array.
	private mutating func setupList(_ list: [T]) {
		var column = 0
		var columnIndex = 0
		
		for object in list {
			if columnIndex < self.columns {
				if columnIndex == 0 {
					self.list.insert([object], at: column)
					columnIndex += 1
					
					/// Show single item on the first row if total items is odd
					if hasBigItem && column == 0 {
						columnIndex = self.columns
					}
				} else {
					self.list[column].append(object)
					columnIndex += 1
				}
			} else {
				column += 1
				self.list.insert([object], at: column)
				columnIndex = 1
			}
		}
	}
	
	private func widthOfItem(numberItemInRow: Int) -> CGFloat {
		if numberItemInRow > 0 {
			return UIScreen.main.bounds.size.width / CGFloat(numberItemInRow)
		} else {
			return UIScreen.main.bounds.size.width/CGFloat(self.columns)
		}
	}
	
	// The Magic goes here
	public var body: some View {
		VStack(spacing: 0) {
			ForEach(0 ..< self.list.count, id: \.self) { index in
				HStack(spacing: 0) {
					ForEach(self.list[index], id: \.self) { object in
						// Your UI defined in the block is called from here.
						self.content(object)
							.frame(width: widthOfItem(numberItemInRow: self.list[index].count))
					}
				}
			}
		}
	}
}
