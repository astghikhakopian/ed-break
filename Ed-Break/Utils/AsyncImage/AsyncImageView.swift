//
//  AsyncImageView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import SwiftUI


struct AsyncImageView: View {

    @ObservedObject var imageLoader: AsynchronousImage
    @State var image = UIImage()

    private let frame: CGRect

    init(withURL url:String, width: CGFloat? = nil, height: CGFloat? = nil) {
        imageLoader = AsynchronousImage(urlString: url)
        frame = CGRect(x: 0, y: 0, width: width ?? 100, height: height ?? 100)
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: frame.width, height: frame.height)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}
