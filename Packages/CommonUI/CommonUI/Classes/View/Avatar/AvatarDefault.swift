//
//  AvatarDefault.swift
//  _NIODataStructures
//
//  Created by MinhDev on 07/06/2022.
//

import SwiftUI

private enum Constants {
    static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
    static let cornerRadius = 4.0
    static let padding = 3.0
    static let lineWidth = 1.5
    static let spacing = 16.0
}

public struct AvatarDefault: View {
    // MARK: - Variables
    @Environment(\.colorScheme) var colorScheme
    @Binding var title: String
    private var imageUrl: URL?

    // MARK: Init
    public init(_ title: Binding<String>, imageUrl: String) {
        self._title = title
        self.imageUrl = URL(string: imageUrl)
    }

    init(_ title: Binding<String>) {
        self.imageUrl = nil
        self._title = title
    }

    // MARK: - Body
    public var body: some View {
        if let imageURL = imageUrl {
            if #available(iOS 15.0, *) {
                CachedAsyncImage(url: imageURL,
                                 urlCache: Constants.imageCache,
                                 content: { image in image.resizable() },
                                 placeholder: { ProgressView() })
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else {
                // Fallback on earlier versions
            }
        } else {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                Text(title.capitalized.prefix(1))
                    .foregroundColor(commonUIConfig.colorSet.offWhite)
                    .font(commonUIConfig.fontSet.font(style: .body3))
            }
        }
    }

}

private extension AvatarDefault {
    var backgroundColor: LinearGradient {
        LinearGradient(gradient: Gradient(colors: commonUIConfig.colorSet.gradientPrimary), startPoint: .leading, endPoint: .trailing)
    }
}
