//
//  SwiftUIView.swift
//  ClearKeep
//
//  Created by MinhDev on 09/03/2022.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
		NavigationView{
		NavigationLink(destination: AdvancedServerView()) {
			Text("sadsd")
		}
		}
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
