//
//  ServerView.swift
//  ClearKeep
//
//  Created by NamNH on 01/03/2022.
//

import SwiftUI

struct ServerView: View {
	
	private var items: [String] = ["a", "b", "c"]
	
    var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(items, id: \.self) { item in
					Text(item)
				}
			}
		}
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
    }
}
